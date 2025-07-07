//
//  CoreDataManager.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 07.07.2025.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    func savePost(_ post: Post) {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", post.id)
        
        do {
            let existingPosts = try context.fetch(fetchRequest)
            if let existingPost = existingPosts.first {
                // Обновляем существующий пост
                updatePost(existingPost, with: post)
            } else {
                // Создаем новый пост
                createNewPost(from: post)
            }
            saveContext()
        } catch {
            print("Failed to fetch or save post: \(error)")
        }
    }
    
    private func createNewPost(from post: Post) {
        let postEntity = PostEntity(context: context)
        postEntity.id = Int32(post.id)
        postEntity.userAvatar = post.userAvatar
        postEntity.userName = post.userName
        postEntity.postDate = post.postDate
        postEntity.postTitle = post.postTitle
        postEntity.postDescr = post.postDescr
        postEntity.postThumbnail = post.postThumbnail
        postEntity.like = Int32(post.like)
        
        post.comments.forEach { comment in
            let commentEntity = CommentEntity(context: context)
            commentEntity.id = comment.id
            commentEntity.name = comment.name
            commentEntity.text = comment.text
            commentEntity.post = postEntity
        }
    }
    
    private func updatePost(_ postEntity: PostEntity, with post: Post) {
        postEntity.userAvatar = post.userAvatar
        postEntity.userName = post.userName
        postEntity.postDate = post.postDate
        postEntity.postTitle = post.postTitle
        postEntity.postDescr = post.postDescr
        postEntity.postThumbnail = post.postThumbnail
        postEntity.like = Int32(post.like)
        
        // Удаляем старые комментарии
        if let comments = postEntity.comments?.allObjects as? [CommentEntity] {
            comments.forEach { comment in
                context.delete(comment)
            }
        }
        
        // Добавляем новые комментарии
        post.comments.forEach { comment in
            let commentEntity = CommentEntity(context: context)
            commentEntity.id = comment.id
            commentEntity.name = comment.name
            commentEntity.text = comment.text
            commentEntity.post = postEntity
        }
    }
    
    func fetchSavedPosts() -> [Post] {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        
        do {
            let postEntities = try context.fetch(fetchRequest)

            return postEntities.map { postEntity in
                let comments = (postEntity.comments?.allObjects as? [CommentEntity])?.map {
                    PostComment(id: $0.id ?? "", name: $0.name ?? "", text: $0.text ?? "")
                } ?? []
                
                return Post(
                    id: Int(postEntity.id),
                    userAvatar: postEntity.userAvatar ?? "",
                    userName: postEntity.userName ?? "",
                    postDate: postEntity.postDate ?? "",
                    postTitle: postEntity.postTitle ?? "",
                    postDescr: postEntity.postDescr ?? "",
                    postThumbnail: postEntity.postThumbnail ?? "",
                    comments: comments,
                    like: Int(postEntity.like)
                )
            }
        } catch {
            print("Failed to fetch posts: \(error)")
            return []
        }
    }
    
    func deletePost(withId id: Int) {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let posts = try context.fetch(fetchRequest)
            posts.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Failed to delete post: \(error)")
        }
    }
}
