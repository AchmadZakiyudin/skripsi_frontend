// android/app/build.gradle.kts
plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // hapus baris ini jika TIDAK pakai Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

// === Load key.properties ===
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "id.azakiyudin.bookingbus"     // <- konsisten dengan package & google-services.json
    compileSdk = 35
    // ndkVersion = "27.0.12077973"           // opsional; hapus jika bikin konflik di mesin lain

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = JavaVersion.VERSION_17.toString() }

    defaultConfig {
        applicationId = "id.azakiyudin.bookingbus"
        minSdk = 23
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        ndk {
            abiFilters += listOf("arm64-v8a", "armeabi-v7a") // 64-bit wajib, 32-bit opsional
        }
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            } else {
                println("WARNING: key.properties tidak ditemukan. Rilis akan unsigned.")
            }
        }
    }

    buildTypes {
        getByName("debug") { /* default */ }

        getByName("release") {
            // ⚠️ JANGAN pakai signingConfigs.debug untuk rilis
            signingConfig = signingConfigs.getByName("release")

            // Kamu bisa nonaktifkan dulu saat debug rilis awal:
            isMinifyEnabled = false
            isShrinkResources = false
            // Nanti kalau sudah stabil, aktifkan untuk ukuran kecil:
            // isMinifyEnabled = true
            // isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    packaging {
        jniLibs { useLegacyPackaging = false } // default modern
        resources {
            excludes += setOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/NOTICE",
                "META-INF/NOTICE.txt"
            )
        }
    }
}

flutter { source = "../.." }
