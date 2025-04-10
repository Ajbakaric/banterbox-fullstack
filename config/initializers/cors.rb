Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://playful-croissant-d2c181.netlify.app' # your Netlify app

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true # if you're using cookies/sessions
  end
end

