defmodule Chunker.TextChunker do
  @moduledoc """
  Splits text into chunks using a recursive splitting method, adhering to defined
  size limits and context overlap. Tracks chunk byte ranges and handles oversized
  chunks with warnings. Supports fallback for non-chunkable text.
  """
  alias Chunker.Splitters.RecursiveSplit

  @default_opts [
    chunk_size: 2000,
    chunk_overlap: 200,
    strategy: &RecursiveSplit.split/2,
    format: :plaintext
  ]

  @doc """
  Splits the provided text into a list of `%Chunk{}` structs.

  ## Options

  * `:chunk_size` (integer, default: 2000) - Maximum size in code point length for each chunk.
  * `:chunk_overlap` (integer, default: 200) - Number of overlapping code points between consecutive chunks to preserve context.
  * `:strategy` (function, default: `&RecursiveSplit.split/2`) - A function taking two arguments (text and options) and returning a list of `%Chunk{}` structs. Currently only `&RecursiveSplit.split/2` is fully supported.
  * `:format` (atom, default: `:plaintext`) - The format of the input text. Used to determine where to split the text in some strategies.

  ## Examples

  ```elixir
  iex> long_text = "This is a very long text that needs to be split into smaller pieces for easier handling."
  iex> Chunker.TextChunker.split(long_text)
  # => [%Chunk{}, %Chunk{}, ...]
  ```

  iex> Chunker.TextChunker.split(long_text, chunk_size: 10, chunk_overlap: 3)
  # => Generates many smaller chunks with significant overlap

  """
  @spec split(binary(), keyword()) :: [Chunk.t()]
  def split(text, opts \\ []) do
    opts = Keyword.merge(@default_opts, opts)

    opts[:strategy].(text, opts)
  end
end
