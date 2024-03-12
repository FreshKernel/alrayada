package net.freshplatform.data.post

interface PostDataSource {
    suspend fun getAllPost(): List<Post>
}