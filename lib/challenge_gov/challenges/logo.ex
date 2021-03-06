defmodule ChallengeGov.Challenges.Logo do
  @moduledoc """
  Handles uploading logos for a challenge
  """

  alias ChallengeGov.Challenges.Challenge
  alias ChallengeGov.Images
  alias ChallengeGov.Repo
  alias Stein.Storage

  @doc """
  Get the storage path for a challenge's logo
  """
  def logo_path(size, key, extension), do: "/challenges/#{size}-#{key}#{extension}"

  def logo_path(challenge = %Challenge{}, size) do
    logo_path(size, challenge.logo_key, challenge.logo_extension)
  end

  @doc """
  Upload a logo if the key is present
  """
  # TODO: Validate logo uploading doesn't happen if upload_logo param is false
  def maybe_upload_logo(challenge, params) do
    params =
      Enum.into(params, %{}, fn {key, value} ->
        {to_string(key), value}
      end)

    case Map.has_key?(params, "logo") do
      true ->
        upload_logo(challenge, Map.get(params, "logo"))

      false ->
        {:ok, challenge}
    end
  end

  def upload_logo(challenge, file) do
    file = Storage.prep_file(file)

    key = UUID.uuid4()
    path = logo_path("original", key, file.extension)
    changeset = Challenge.logo_changeset(challenge, key, file.extension)

    with :ok <- upload(file, path),
         {:ok, challenge} <- Repo.update(changeset) do
      generate_thumbnail(challenge, file)
    else
      {:error, :invalid_extension} ->
        challenge
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.add_error(:logo, "must be a jpg, png, or gif")
        |> Ecto.Changeset.apply_action(:update)

      {:error, _reason} ->
        challenge
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.add_error(:logo, "had an issue uploading")
        |> Ecto.Changeset.apply_action(:update)
    end
  end

  defp upload(file, path) do
    Storage.upload(file, path, extensions: [".jpg", ".jpeg", ".png", ".gif"])
  end

  def generate_thumbnail(challenge, file) do
    path = logo_path(challenge, "thumbnail")

    case Images.convert(file, extname: file.extension, thumbnail: "600x600") do
      {:ok, temp_path} ->
        upload(%{path: temp_path}, path)
        File.rm(temp_path)

        {:ok, challenge}

      {:error, :convert} ->
        {:ok, challenge}
    end
  end
end
