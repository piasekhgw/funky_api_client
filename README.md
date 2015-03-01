# FunkyApiClient

Simple ORM for json API responses mapping based on [virtus](https://github.com/solnic/virtus)
and [httparty](https://github.com/jnunemaker/httparty) gems.

To make gem working you need to specify base url for your backend:
```ruby
FunkyApiClient.backend_url = 'http://your-backend.com'
```

## class_call method

Use `class_call` method to map API response to object or collection of objects.

You can also set `plain_response` option to get pure API response.

This method always performs GET requests.
```ruby
def class_call(method_name, relative_path, plain_response = false)
```

Let's consider following example:
```ruby
class Car < FunkyApiClient::Base
  class_call :count, 'cars/:id/count', true
  class_call :fetch, 'cars/fetch'

  attribute :id
  attribute :brand
end
```
Assuming that our API returns `'123'` for `cars/1/count` endpoint, we can use `Car.count(params: { id: 1 })` to return `'123'`.

Notice that we used `params` hash. This hash can contain ruote params and query params. We can also pass `headers` hash to this method.

Let's say our `cars/fetch` endpoint returns json like `[{"id":1,"brand":"Audi"},{"id":2,"brand":"Mercedes"}]`.
`Car.fetch` call will return collection of `Car` objects.

Json like `{"id":1,"brand":"Audi"}` will be mapped to single `Car` object.

## instance_call method

Use `instance_call` method to send state of the object to the API. This method also assigns response errors if needed.
```ruby
def instance_call(method_name, relative_path, method_type, serialization_method_name = nil)
```
Parameter `serialization_method_name` must be name of the method that returns serialized object in json format.

E.g.
```ruby
class Car < FunkyApiClient::Base
  instance_call :create, 'cars', :post, :create_json

  attribute :id
  attribute :brand
  attribute :color

  def create_json
    { brand: brand, color: color }.to_json
  end
end

car = Car.new(brand: 'Audi', color: 'red')
car.create # returns true if response successful, otherwise false
```
If response status was 422 and response json was like `{"errors": ["brand is invalid"]}` then `car` has `response_errors` set.
