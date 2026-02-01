defmodule ElixirStarterIntegrationTest do
  @moduledoc """
  Integration tests that call actual BAML functions.

  These tests require OPENAI_API_KEY to be set in the environment.
  Run with: OPENAI_API_KEY=your_key mix test --only integration
  """
  alias ElixirStarter.BamlClient
  use ExUnit.Case

  @moduletag :integration

  @sample_resume """
  Jane Smith
  123 Main Street
  Boston, MA 02101

  Education:
  Bachelor of Science in Computer Science
  MIT
  2018 - 2022

  Skills: Python, Elixir, JavaScript, SQL
  """

  describe "extract_resume/1" do
    @tag timeout: 60_000
    test "extracts resume information synchronously" do
      {:ok, resume} = ElixirStarter.extract_resume(@sample_resume)

      assert %ElixirStarter.Resume{} = resume
      assert is_binary(resume.name)
      assert resume.name =~ "Jane" or resume.name =~ "Smith"
      assert is_list(resume.education)
      assert is_list(resume.skills)
    end

    @tag timeout: 60_000
    test "extracts education details" do
      {:ok, resume} = ElixirStarter.extract_resume(@sample_resume)

      assert length(resume.education) >= 1

      education = hd(resume.education)
      assert %ElixirStarter.Education{} = education
      assert is_binary(education.school)
      assert is_binary(education.degree)
      assert is_integer(education.year)
    end

    @tag timeout: 60_000
    test "extracts skills" do
      {:ok, resume} = ElixirStarter.extract_resume(@sample_resume)

      assert length(resume.skills) >= 1
      assert Enum.all?(resume.skills, &is_binary/1)
    end
  end

  describe "extract_resume_stream/2" do
    @tag timeout: 60_000
    test "streams partial results and returns final result" do
      chunks = :ets.new(:chunks, [:set, :public])
      counter = :counters.new(1, [])

      {:ok, final_resume} =
        ElixirStarter.extract_resume_stream(
          fn partial ->
            idx = :counters.add(counter, 1, 1)
            :ets.insert(chunks, {idx, partial})
          end,
          @sample_resume
        )

      chunk_count = :counters.get(counter, 1)

      # Should have received at least one partial update
      assert chunk_count >= 1

      # Final result should be a complete Resume struct
      assert %ElixirStarter.Resume{} = final_resume
      assert is_binary(final_resume.name)

      :ets.delete(chunks)
    end
  end

  describe "ExtractResume.call/2 direct" do
    @tag timeout: 60_000
    test "can call ExtractResume directly" do
      {:ok, resume} = BamlClient.ExtractResume.call(%{raw_text: @sample_resume})

      assert %ElixirStarter.Resume{} = resume
      assert is_binary(resume.name)
    end
  end
end
