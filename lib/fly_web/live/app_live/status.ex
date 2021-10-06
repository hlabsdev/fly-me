defmodule FlyWeb.AppLive.Status do
  use FlyWeb, :live_view
  require Logger

  alias Fly.Client
  alias FlyWeb.Components.HeaderBreadcrumbs
  alias Calendar

  @impl true
  def mount(%{"name" => name}, session, socket) do
    socket =
      assign(
        socket,
        config: client_config(session),
        state: :loading,
        status: nil,
        app_name: name,
        authenticated: true
      )

    if connected?(socket) do
      {:ok, fetch_appstatus(socket)}
    else
      {:ok, socket}
    end
  end

  defp client_config(session) do
    Fly.Client.config(access_token: session["auth_token"] || System.get_env("FLYIO_ACCESS_TOKEN"))
  end

  # Hlabs: get the current app status
  defp fetch_appstatus(socket) do
    app_name = socket.assigns.app_name

    case Client.fetch_appstatus(app_name, socket.assigns.config) do
      {:ok, status} ->
        assign(socket, :status, status)

      {:error, :unauthorized} ->
        put_flash(socket, :error, "Not authenticated")

      {:error, reason} ->
        Logger.error(
          "Failed to load app' status '#{inspect(app_name)}'. Reason: #{inspect(reason)}"
        )

        put_flash(socket, :error, reason)
    end
  end

  def status_bg_color(app) do
    case app["status"] do
      "running" -> "bg-green-100"
      "dead" -> "bg-red-100"
      _ -> "bg-yellow-100"
    end
  end

  def status_text_color(app) do
    case app["status"] do
      "running" -> "text-green-800"
      "dead" -> "text-red-800"
      _ -> "text-yellow-800"
    end
  end

  def instance_health(instance) do
    case instance["healthy"] do
      true -> "Healthy"
      false -> "Unhealthy"
      nil -> "Unknown"
      _ -> "Unknown"
    end
  end

  def instance_health_loader(instance) do
    case instance["healthy"] do
      true -> "loader-healthy"
      false -> "loader-unhealthy"
      nil -> "loader-unknown"
      _ -> "loader-unknown"
    end
  end

  @minute 60
  @hour   @minute*60
  @day    @hour*24
  @week   @day*7
  @month   @day*30
  @divisor [@month, @week, @day, @hour, @minute, 1]
  def sec_to_str(date) do
    {_, [s, m, h, d, w, mth]} =
        Enum.reduce(@divisor, {time_lapse(date),[]}, fn divisor,{n,acc} ->
          {rem(n,divisor), [div(n,divisor) | acc]}
        end)
    ["#{mth} mth", "#{w} wk", "#{d} d", "#{h} hr", "#{m} min", "#{s} sec"]
    |> Enum.reject(fn str -> String.starts_with?(str, "0") end)
    |> Enum.join(", ")
  end

  def time_lapse(date) do
    NaiveDateTime.local_now()
    |>NaiveDateTime.diff(NaiveDateTime.from_iso8601!(date))
  end

  def convert_date(date) do
    NaiveDateTime.from_iso8601!(date)
    |> Calendar.strftime("%a, %d %b %Y at %H:%M:%S")
  end


  def preview_url(app) do
    "https://#{app["name"]}.fly.dev"
  end

end
