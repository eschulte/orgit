# Methods added to this helper will be available to all templates in the application.
module ActiveFileHelper

  def af_id(params)
    params[:rest].join("/")
  end

  def af_path(action, af, options = {})
    path = ["", action.to_s, af.to_s].join("/")
    if options.keys.include?(:format) or options.keys.include?('format')
      path = $1 if path.match("^(.+)\\.(.+?)$")
      if options[:format]
        "#{path}.#{options[:format]}"
      else
        path
      end
    else
      path
    end
  end

end
