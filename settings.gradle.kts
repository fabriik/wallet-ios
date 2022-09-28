rootProject.name = "brd-mobile"

include(
    "cosmos-core",
    "cosmos-brd-api-client",
    //"cosmos-websocket",
    "cosmos-bundled",
    "cosmos-preferences",
    "cosmos-bakers-api-client"
)

include(
    "brd-android:app",
    "brd-android:app-core",
    "brd-android:theme"
)

includeBuild("external/redacted-compiler-plugin") {
    dependencySubstitution {
        substitute(module("dev.zacsweers.redacted:redacted-compiler-gradle-plugin"))
            .with(project(":redacted-compiler-plugin-gradle"))
        substitute(module("dev.zacsweers.redacted:redacted-compiler-plugin-annotations"))
            .with(project(":redacted-compiler-plugin-annotations"))
    }
}
