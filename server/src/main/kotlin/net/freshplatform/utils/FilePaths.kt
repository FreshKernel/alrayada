package net.freshplatform.utils

import java.io.File

sealed class FilePaths {
    abstract fun getDirectory(): File
    data object Uploads: FilePaths() {
        // If you change this, you will also need to change it from the .gitignore
        override fun getDirectory() = File("uploads")

        data object Products: FilePaths() {
            override fun getDirectory() = File(Uploads.getDirectory(), "products")

            data object Categories: FilePaths() {
                override fun getDirectory() = File(Products.getDirectory(), "categories")
            }
        }
    }
}