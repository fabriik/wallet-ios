package com.fabriik.signup.ui.kyc.idupload

import android.content.ContentValues
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.IntRange
import androidx.annotation.StringRes
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageCapture
import androidx.camera.core.ImageCaptureException
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.fabriik.signup.R
import com.fabriik.signup.databinding.FragmentKycCompleteBinding
import com.fabriik.signup.databinding.FragmentKycIdUploadBinding
import com.fabriik.signup.ui.base.FabriikView
import com.fabriik.signup.utils.hideKeyboard
import kotlinx.coroutines.flow.collect
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

abstract class KycBaseIdUploadFragment : Fragment(),
    FabriikView<KycBaseIdUploadContract.State, KycBaseIdUploadContract.Effect> {

    private lateinit var binding: FragmentKycIdUploadBinding
    private lateinit var cameraExecutor: ExecutorService

    private val viewModel: KycBaseIdUploadViewModel by lazy {
        ViewModelProvider(this).get(KycBaseIdUploadViewModel::class.java)
    }

    private val imageCapture = ImageCapture.Builder().build()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_kyc_id_upload, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentKycIdUploadBinding.bind(view)

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

            // setup Progress indicator
            pbIndicator.progress = getKycFlowStep()

            // setup title
            tvTitle.setText(getUploadTitle())

            // setup description
            tvDescription.setText(getUploadDescription())
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

        cameraExecutor = Executors.newSingleThreadExecutor()
    }

    override fun onStart() {
        super.onStart()

        viewModel.setEvent(
            KycBaseIdUploadContract.Event.FragmentStarted
        )
    }

    override fun onDestroy() {
        super.onDestroy()
        cameraExecutor.shutdown()
    }

    override fun render(state: KycBaseIdUploadContract.State) {
        with(binding) {
            btnNext.isEnabled = state.nextEnabled
            btnRetry.isEnabled = state.retryEnabled
            btnTakePhoto.isEnabled = state.takePhotoEnabled
        }
    }

    override fun handleEffect(effect: KycBaseIdUploadContract.Effect) {
        when (effect) {
            is KycBaseIdUploadContract.Effect.GoToNextStep -> goToNextStep()
            is KycBaseIdUploadContract.Effect.ShowPreview -> startCamera()
        }
    }

    private fun startCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(requireContext())

        cameraProviderFuture.addListener({
            // Used to bind the lifecycle of cameras to the lifecycle owner
            val cameraProvider: ProcessCameraProvider = cameraProviderFuture.get()

            // Preview
            val preview = Preview.Builder()
                .build()
                .also {
                    it.setSurfaceProvider(binding.viewFinder.surfaceProvider)
                }

            // Select back camera as a default
            val cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA

            try {
                // Unbind use cases before rebinding
                cameraProvider.unbindAll()

                // Bind use cases to camera
                cameraProvider.bindToLifecycle(
                    this, cameraSelector, preview
                )

            } catch (exc: Exception) {
                //Log.e(TAG, "Use case binding failed", exc)
            }

        }, ContextCompat.getMainExecutor(requireContext()))
    }

    private fun takePhoto() {
        val name = SimpleDateFormat("image_%d", Locale.US)
            .format(System.currentTimeMillis())

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
        imageCapture.takePicture(
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

    @IntRange(from = 3, to = 5)
    protected abstract fun getKycFlowStep(): Int

    protected abstract fun getPhotoType(): KycUploadPhotoType

    @StringRes
    protected abstract fun getUploadTitle(): Int

    @StringRes
    protected abstract fun getUploadDescription(): Int

    protected abstract fun goToNextStep()
}