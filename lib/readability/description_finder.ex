defmodule Readability.DescriptionFinder do
  @moduledoc """
  The DescriptionFinder engine traverses HTML tree searching for finding a short description.
  """

  @type html_tree :: tuple | list

  @doc """
  Find proper description.
  """
  @spec description(html_tree) :: binary
  def description(html_tree) do
    case og_description(html_tree) do
      "" ->
        ""

      description when is_binary(description) ->
        description
    end
  end

  @doc """
  Find description from `og:description` property of meta tag.
  """
  @spec og_description(html_tree) :: binary
  def og_description(html_tree) do
    html_tree
    |> find_tag("meta[property='og:description']")
    |> Floki.attribute("content")
    |> clean_description()
  end

  defp find_tag(html_tree, selector) do
    case Floki.find(html_tree, selector) do
      [] ->
        []

      matches when is_list(matches) ->
        hd(matches)
    end
  end

  defp clean_description([]) do
    ""
  end

  defp clean_description([description]) when is_binary(description) do
    String.trim(description)
  end

  defp clean_description(html_tree) do
    html_tree
    |> Floki.text()
    |> String.trim()
  end

  defp good_description(description) do
    length(String.split(description, " ")) >= 4
  end
end
