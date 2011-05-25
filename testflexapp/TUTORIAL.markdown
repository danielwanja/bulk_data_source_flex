### Create the todo Rails app
rvm use 1.9.2@bulk_data_source

rails new todos
cd todos

In GemFile

gem 'bulk_api'

# Rails fixes/hacks
gem 'sprockets', :git => 'git://github.com/sstephenson/sprockets.git'

rails generate bulk:install
rails g scaffold todo title:string done:boolean
rake db:migrate


in application.rb add
    config.middleware.delete(Rack::Lock)


rails s

### Create the todos Flex app

* copy the bulk_data_source.swc and as3corelib. Optionally flexlib.swc for the PromptingText component.
* Create the Todo class

```javascript
	package resources
	{
		import bulk_api.BulkResource;
	
		[RemoteClass(alias="Todo")]	
		public dynamic class Todo extends BulkResource
		{
			public function Todo(attributes:Object=null) {
				super(attributes);
			}
		
			resource("todos", Todo)
		}
	}
```

* Add the loadAll function to create

```xml
	<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009"
				   xmlns:s="library://ns.adobe.com/flex/spark"
				   xmlns:flexlib="http://code.google.com/p/flexlib/"
				   creationComplete="loadAll()">
```

