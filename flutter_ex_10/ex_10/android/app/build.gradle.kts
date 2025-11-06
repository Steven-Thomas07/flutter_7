plugins {
    id("com.android.application")
    id("kotlin-android")

    // ✅ The Flutter Gradle Plugin must come *after* Android + Kotlin
    id("dev.flutter.flutter-gradle-plugin")

    // ✅ Add Google Services plugin for Firebase
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.ex_10"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.ex_10"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Firebase BoM — controls versions of Firebase SDKs
    implementation(platform("com.google.firebase:firebase-bom:34.3.0"))

    // (Optional) — You can add Firestore explicitly if you like:
    // implementation("com.google.firebase:firebase-firestore")
}
