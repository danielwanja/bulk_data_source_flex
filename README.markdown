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
    BulkResource.create(Todo, {posts:new ArrayCollection([post])});
```

### RoadMap

1. Error Support
2. More test around nested resources
3. DataSource that tracks changes and automatically syncs with the server

### Screencast

Checkout my screencast [Building Rails App for Rich Client](http://www.onrails.org/2011/05/27/building-rails-apps-for-rich-client-using-the-bulk_api-from-flex) in which I show how to build a Rails app in a couple of minutes that is optimized for Rich Client. The application is a todo application build in Flex connecting using the [bulk_api](https://github.com/drogus/bulk_api) to the Rails server using my new bulk data source Flex framework.

### Community

Want to help? Contact Daniel Wanja d@n-so.com

Enjoy!
Daniel Wanja

