defmodule PopulusWeb.Router do
  use PopulusWeb, :router

  import PopulusWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PopulusWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PopulusWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Just playing with Bumblebee etc rn - a playground
  scope "/", PopulusWeb do
    pipe_through :browser

    live "/messages/playground", Messages.Playground
  end

  # Other scopes may use custom stacks.
  # scope "/api", PopulusWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:populus, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PopulusWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", PopulusWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{PopulusWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", PopulusWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{PopulusWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/comments", CommentLive.Index, :index
      live "/comments/new", CommentLive.Index, :new
      live "/comments/:id/edit", CommentLive.Index, :edit
      live "/comments/:id", CommentLive.Show, :show
      live "/comments/:id/show/edit", CommentLive.Show, :edit

      live "/questions", QuestionLive.Index, :index
      live "/questions/new", QuestionLive.Index, :new
      live "/questions/:id/edit", QuestionLive.Index, :edit
      live "/questions/:id", QuestionLive.Show, :show
      live "/questions/:id/show/edit", QuestionLive.Show, :edit

      live "/project_docs", ProjectDocLive.Index, :index
      live "/project_docs/new", ProjectDocLive.Index, :new
      live "/project_docs/:id/edit", ProjectDocLive.Index, :edit

      live "/project_docs/:id", ProjectDocLive.Show, :show
      live "/project_docs/:id/show/edit", ProjectDocLive.Show, :edit
    end
  end

  scope "/", PopulusWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{PopulusWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
