# WARNING: Still under heavy development ;) In fact I just started on the return from RailsConf 2011! 

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
	[RemoteClass(alias="Author")]
	public dynamic class Author extends BulkResource
	{
		resource("authors", Author);   // associate resource class...Hope I can determine this based on RemoteClass tag.
	}

	[RemoteClass(alias="Post")]	
	public dynamic class Post extends BulkResource {
		resource("posts", Post)		
	}
	
	[RemoteClass(alias="Comment")]	
	public dynamic class Comment extends BulkResource {
		resource("comments", Comment);		
	}
```

Find all authors with posts and comments:

Note the server side define the attributes and associations to be returned. So if you have the following on the Rails all authors, their posts and comments with all attributes will be returned. They are several options to find tune this and you can even has the as_json method at the ApplicationResource if you need to drive the response based on the user session.

```ruby
	class Author < ActiveRecord::Base
  
	  def as_json(options={})
	    super(:include =>{:posts => {:include  => :comments}}) 
	  end

	end
```

You can then query these nested objects from ActionScript:

```javascript
    var call:AsyncToken = BulkResource.findAll(Post);
```
or
```javascript
    var call:AsyncToken = BulkResource.find(Post, 1);
```

Create one post:

```javascript
	var post:Post = new Post()
	post.body = "Simple way to interact with Rails"
	post.comments = new ArrayCollection
	var comment:Comment = new Comment({content:'Using RDD - Readme Driven Development'})
	post.comments.addItem(comment)
	BulkResource.save(post)
```

### Mananged Service

```javascript
     BulkResource.autoCommit = true;
	// Now any changes is queue and regularly sent to the server.
```

###  Empty Objects

Objects can be autoloaded when needed

```javascript
	BulkResource.find(Post,1, {empty:'comments'}) 
	// returns Post with comments collection without attributes, just the ids
	// Object can be loaded incrementally as needed.
```

### Server Side Validations

Based on https://github.com/bcardarella/client_side_validations

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

