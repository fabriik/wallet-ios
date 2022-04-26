package com.fabriik.signup.ui.kyc.idupload

import android.Manifest
import android.content.ContentValues
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.activity.result.contract.ActivityResultContracts
import androidx.camera.core.*
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import androidx.core.view.isInvisible
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import com.bumptech.glide.Glide
import com.fabriik.signup.R
import com.fabriik.signup.databinding.FragmentKycIdUploadBinding
import com.fabriik.signup.ui.SignupActivity
import com.fabriik.signup.ui.base.FabriikView
import com.fabriik.signup.utils.SnackBarUtils
import kotlinx.coroutines.flow.collect
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

abstract class KycBaseIdUploadFragment<ViewModel: KycBaseIdUploadViewModel> : Fragment(),
    FabriikView<KycBaseIdUploadContract.State, KycBaseIdUploadContract.Effect> {

    private lateinit var binding: FragmentKycIdUploadBinding
    private lateinit var cameraExecutor: ExecutorService

    private var lensFacing = CameraSelector.LENS_FACING_BACK
    private var imageCapture: ImageCapture? = null
    private var cameraProvider: ProcessCameraProvider? = null

    private val permissionsLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) {
        viewModel.setEvent(
            KycBaseIdUploadContract.Event.CameraPermissionResult(it)
        )
    }

    protected abstract val viewModel: ViewModel

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_kyc_id_upload, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding = FragmentKycIdUploadBinding.bind(view)
        cameraExecutor = Executors.newSingleThreadExecutor()

        with(binding) {
            // setup "Next" button
            btnNext.setOnClickListener {
                viewModel.setEvent(
                    KycBaseIdUploadContract.Event.NextClicked
                )
            }

            // setup "Retry" button
            btnRetry.setOnClickListener {
                viewModel.setEvent(
                    KycBaseIdUploadContract.Event.RetryClicked
                )
            }

            // setup "Take Photo" button
            btnTakePhoto.setOnClickListener {
                viewModel.setEvent(
                    KycBaseIdUploadContract.Event.TakePhotoClicked
                )
            }

            // setup "Switch camera" button
            btnSwitchCamera.setOnClickListener {
                viewModel.setEvent(
                    KycBaseIdUploadContract.Event.SwitchCameraClicked
                )
            }
        }

        // collect UI state
        lifecycleScope.launchWhenStarted {
            viewModel.state.collect {
                render(it)
            }
        }

        // collect UI effect
        lifecycleScope.launchWhenStarted {
            viewModel.effect.collect {
                handleEffect(it)
            }
        }

        lifecycle.addObserver(viewModel)
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)

        bindCameraUseCases()
        updateCameraSwitchButton()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        cameraExecutor.shutdown()
    }

    override fun render(state: KycBaseIdUploadContract.State) {
        with(binding) {
            tvTitle.setText(state.title)
            tvDescription.setText(state.description)
            pbIndicator.progress = state.kycStepProgress

            btnNext.isEnabled = state.nextEnabled
            btnRetry.isEnabled = state.retryEnabled
            btnTakePhoto.isEnabled = state.takePhotoEnabled
            //btnSwitchCamera.isVisible = state.switchCameraVisible

            if (state.imageUri != null) {
                ivImage.isVisible = true
                viewFinder.isInvisible = true

                Glide.with(root.context)
                    .load(state.imageUri)
                    .into(ivImage)
            } else {
                ivImage.isVisible = false
                viewFinder.isVisible = true
            }
        }
    }

    override fun handleEffect(effect: KycBaseIdUploadContract.Effect) {
        when (effect) {
            is KycBaseIdUploadContract.Effect.RequestCameraPermission ->
                permissionsLauncher.launch(Manifest.permission.CAMERA)

            is KycBaseIdUploadContract.Effect.SetupCamera ->
                binding.viewFinder.post { setUpCamera() }

            is KycBaseIdUploadContract.Effect.GoToNextStep ->
                goToNextStep()

            is KycBaseIdUploadContract.Effect.TakePhoto ->
                takePhoto(effect.type)

            is KycBaseIdUploadContract.Effect.SwitchCamera ->
                switchCamera()

            is KycBaseIdUploadContract.Effect.ShowLoading -> {
                val activity = activity as SignupActivity?
                activity?.showLoading(effect.show)
            }

            is KycBaseIdUploadContract.Effect.ShowSnackBar ->
                SnackBarUtils.showLong(
                    view = binding.root,
                    text = effect.message
                )
        }
    }

    private fun setUpCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(requireContext())
        cameraProviderFuture.addListener({

            // CameraProvider
            cameraProvider = cameraProviderFuture.get()

            // Select lensFacing depending on the available cameras
            lensFacing = when {
                hasBackCamera() -> CameraSelector.LENS_FACING_BACK
                hasFrontCamera() -> CameraSelector.LENS_FACING_FRONT
                else -> throw IllegalStateException("Back and front camera are unavailable")
            }

            // Enable or disable switching between cameras
            updateCameraSwitchButton()

            // Build and bind the camera use cases
            bindCameraUseCases()
        }, ContextCompat.getMainExecutor(requireContext()))
    }

    private fun bindCameraUseCases() {
        val cameraProvider = cameraProvider
            ?: throw IllegalStateException("Camera initialization failed.")

        val rotation = binding.viewFinder.display.rotation

        val preview = Preview.Builder()
            .setTargetRotation(rotation)
            .build()
            .also {
                it.setSurfaceProvider(binding.viewFinder.surfaceProvider)
            }

        imageCapture = ImageCapture.Builder()
            .setTargetRotation(rotation)
            .build()

        val cameraSelector = CameraSelector.Builder()
            .requireLensFacing(lensFacing)
            .build()

        try {
            // Unbind use cases before rebinding
            cameraProvider.unbindAll()

            // Bind use cases to camera
            cameraProvider.bindToLifecycle(
                this, cameraSelector, preview, imageCapture
            )
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
    }

    private fun updateCameraSwitchButton() {
        binding.btnSwitchCamera.isVisible = try {
            hasBackCamera() && hasFrontCamera()
        } catch (ex: CameraInfoUnavailableException) {
            false
        }
    }

    private fun switchCamera() {
        lensFacing = if (CameraSelector.LENS_FACING_FRONT == lensFacing) {
            CameraSelector.LENS_FACING_BACK
        } else {
            CameraSelector.LENS_FACING_FRONT
        }

        bindCameraUseCases()
    }

    private fun takePhoto(type: KycUploadPhotoType) {
        val name = "image_${type.id}"

        val contentValues = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, name)
            put(MediaStore.MediaColumns.MIME_TYPE, "image/jpeg")
            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.P) {
                put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/CameraX-Image")
            }
        }

        // Create output options object which contains file + metadata
        val outputOptions = ImageCapture.OutputFileOptions.Builder(
            requireContext().contentResolver,
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
            contentValues
        ).build()

        // Set up image capture listener, which is triggered after photo has
        // been taken
        imageCapture?.takePicture(
            outputOptions,
            ContextCompat.getMainExecutor(requireContext()),
            object : ImageCapture.OnImageSavedCallback {
                override fun onError(exc: ImageCaptureException) {
                    viewModel.setEvent(
                        KycBaseIdUploadContract.Event.TakePhotoFailed
                    )
                }

                override fun onImageSaved(output: ImageCapture.OutputFileResults) {
                    viewModel.setEvent(
                        if (output.savedUri == null) {
                            KycBaseIdUploadContract.Event.TakePhotoFailed
                        } else {
                            KycBaseIdUploadContract.Event.TakePhotoCompleted(
                                output.savedUri!!
                            )
                        }
                    )
                }
            }
        )
    }

    private fun hasBackCamera(): Boolean {
        return cameraProvider?.hasCamera(CameraSelector.DEFAULT_BACK_CAMERA) ?: false
    }

    private fun hasFrontCamera(): Boolean {
        return cameraProvider?.hasCamera(CameraSelector.DEFAULT_FRONT_CAMERA) ?: false
    }

    protected abstract fun goToNextStep()
}