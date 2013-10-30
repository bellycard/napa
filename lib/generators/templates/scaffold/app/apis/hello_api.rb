module HelloService
  class API < Grape::API
    format :json

    resource :hello do 
      desc "Return a Hello World message"
      get do
        {message: "Hello Wonderful World!"}
      end
    end

  end
end
