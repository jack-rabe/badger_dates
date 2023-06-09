defmodule BadgerDatesWeb.Router do
  use BadgerDatesWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BadgerDatesWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]

    # UserLinks routes
    get "/links/:user_id", UserController, :links
    get "/links/:user_id/next", UserController, :get_potential_match
    get "/links/:user_id/confirmed_matches", UserController, :get_confirmed_matches
    patch "/accept_match/:user_id/:other_id", UserController, :accept_match
    patch "/decline_match/:user_id/:other_id", UserController, :decline_match
    # messages routes
    resources "/messages", MessageController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BadgerDatesWeb.Telemetry
    end
  end
end
