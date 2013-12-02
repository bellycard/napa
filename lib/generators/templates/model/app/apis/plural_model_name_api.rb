class model_name_camel_pluralApi < Grape::API
  format :json

  desc 'Get a list of plural_model_name using parameters as a filter'
  params do

  end
  get do
    present model_name_camel.all, with: model_name_camelEntity
  end

  desc 'Create a new model_name'
  params do

  end
  post do
    model_name = model_name_camel.create
    present model_name, with: model_name_camelEntity
  end


  route_param :id do
    desc 'Update the model_name'
    params do

    end
    put do
      model_name = model_name_camel.where(id: params[:id]).first
      # update something
      present model_name, with: model_name_camelEntity
    end

    desc 'Get the model_name by id'
    get do
      model_name = model_name_camel.where(id: params[:id]).first
      present model_name, with: model_name_camelEntity
    end
  end
end
