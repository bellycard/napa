Converting from Napa::Entity to Napa::Representer
=====================================

The fastest way to figure this out is by example.

Here are two objects, an Entity and a Representer, that create the __exact same API response__:

### Entity
```ruby
class FooEntity < Napa::Entity
  root :data, :data

  expose  :some_attr,
          :other_attr

  expose :weird_name, as: sane_name

  expose :collection_of_things

  expose :id, format_with: to_s, documentation:
    {type: 'String', description: 'ID'}

  expose :bar, using: BarEntity
  expose :caz, using: CazEntity, if: lambda { |instance, opts| opts[:blah] == instance.blah }

  expose :use_a_method do
    some_property < 100
  end
end
```

### Representer
```ruby
class FooRepresenter < Napa::Representer
  property :some_attr
  property :other_attr

  property :weird_name, as: sane_name

  collection :collection_of_things

  property :id, type: String

  property :bar, decorator: BarRepresenter
  property :caz, decorator: CazEntity, if: lambda { |opts| opts[:blah] == @blah }

  property :use_a_method, exec_context: :decorator

  def use_a_method
    represented.some_property < 100
  end

end
```

Check out the options on Representers if there are other cases:

https://github.com/apotonick/representable#available-options

### Some Gotchas

In your `Grape::API`, you'll something like this for Entities:

```
desc 'whatever', entity: FooEntity
get do
  # code code
  present foo, with: FooEntity
end
```

Do this instead:

```
desc 'whatever'
get do
  # code code
  represent foo, with: FooRepresenter
end
```

Change `present` to `represent`

---

`Napa::Entity` defines the following convenience methods

```ruby
  format_with :to_s do |val|
    val.to_s
  end

  def object_type
    object.class.name.underscore
  end
```

These may be defined inline for your Entities if they're not using Napa::Entity

---

There is no `Boolean` class in Ruby, but in `Napa:Entity` you can do `type: 'Boolean'`.

If it's a boolean in the database, you don't have to worry about it. If not, convert it in lambda method:

```ruby
class FooRepresenter < Napa::Representer
  property :some_string, getter: lambda { |opts| @value == "weird" }
end
```
