# Methods added to this helper will be available to all templates in the application.
module ActiveFileHelper

  def af_id()
    params[:rest].join("/")
  end

  def af_path(action, af, options = {})
    path = ["", action.to_s, af.to_s].join("/")
    path = force_extension(path, options.delete(:format)) if options.keys.include?(:format)
    if options.size > 0
      path + "?" + options.map{ |key, value| "#{key}=#{value}" }.join("&")
    else
      path
    end
  end
  
  # if new_extension is not true, then any existing extension will be stripped
  def force_extension(path, new_extension = nil)
    path = $1 if path.match("^(.+)\\.(.+?)$")
    if new_extension
      "#{path}.#{new_extension}"
    else
      path
    end
  end

end
