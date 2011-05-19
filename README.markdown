# WARNING: Still under heavy maintenance ;) In fact I just started today!

# BulkDataSource - An ActionScript Framework to integrate with Ruby on Rails

A Flex/ActionScript Framework to integrate with Ruby on Rails using the 'bulk_api' gem

## Installing:

### Rails app:

Add this line to Gemfile and run bundle install:
```ruby
gem 'bulk_api'
```

To set up Bulk API in your Rails app:
```
	rails generate bulk:install
```

### Flex App

Copy the build_data_source.swc to the lib folder of you application.

## Usage

First create a dynamic class that maps to a resource:
```javascript
	public dynamic class Post extends BulkResource {
		
	}
	
	public dynamic class Comment extends BulkResource {
		
	}
```

Find all posts with comments:
```javascript
    var posts:BulkArrayCollection = BulkResource.findAll(Post, {'include':'comments'})
```

Create one post:
```javascript
	var post:Post = new Post()
	post.body = "Simple way to interact with Rails"
	post.comments = new BulkArrayCollection
	var comment:Comment = new Comment({content:'Using RDD - Readme Driven Development'})
	post.comments.addItem(comment)
	BulkResource.save(post)
```

### Mananged Service

```javascript
     BulkDataSource.autoCommit = true;
	// Now any changes is queue and regularly sent to the server.
```

###  Empty Objects

Objects can be querying when needed

```javascript
	BulkResource.find(Post,1, {empty:'comments'}) 
	// returns Post with comments collection without attributes, just the ids
	// Object can be loaded incrementally as needed.
```

### Server Side Validations


### Uniqueing 

Memory map instance by class type and object id to ensure uniqueness in memory.

### RoadMap

1. Serialize/Deserialize
2. CRUD rest requests
3. ... let's take it one step at a time.

### Community

Want to help? Contact Daniel Wanja d@n-so.com

Enjoy!
Daniel Wanja

