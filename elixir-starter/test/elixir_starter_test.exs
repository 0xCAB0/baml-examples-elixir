defmodule ElixirStarterTest do
  use ExUnit.Case

  describe "generated BAML types" do
    test "Resume struct is generated with correct fields" do
      resume = %ElixirStarter.Resume{
        name: "John Doe",
        education: [],
        skills: ["Python", "Elixir"]
      }

      assert resume.name == "John Doe"
      assert resume.skills == ["Python", "Elixir"]
      assert resume.education == []
    end

    test "Education struct is generated with correct fields" do
      education = %ElixirStarter.Education{
        school: "MIT",
        degree: "BS Computer Science",
        year: 2020
      }

      assert education.school == "MIT"
      assert education.degree == "BS Computer Science"
      assert education.year == 2020
    end

    test "Resume can contain Education structs" do
      education = %ElixirStarter.Education{
        school: "Stanford",
        degree: "MS",
        year: 2022
      }

      resume = %ElixirStarter.Resume{
        name: "Jane Doe",
        education: [education],
        skills: []
      }

      assert length(resume.education) == 1
      assert hd(resume.education).school == "Stanford"
    end

    test "MyEnum module is generated with correct values" do
      values = ElixirStarter.MyEnum.values()
      assert :VALUE1 in values
      assert :VALUE2 in values
      assert :VALUE3 in values
      assert length(values) == 3
      assert ElixirStarter.MyEnum.type() == :enum
    end
  end

  describe "ExtractResume function module" do
    test "ExtractResume module exists with call/2 function" do
      assert function_exported?(ElixirStarter.ExtractResume, :call, 1)
      assert function_exported?(ElixirStarter.ExtractResume, :call, 2)
    end

    test "ExtractResume module exists with stream/3 function" do
      assert function_exported?(ElixirStarter.ExtractResume, :stream, 2)
      assert function_exported?(ElixirStarter.ExtractResume, :stream, 3)
    end

    test "ExtractResume module exists with sync_stream/3 function" do
      assert function_exported?(ElixirStarter.ExtractResume, :sync_stream, 2)
      assert function_exported?(ElixirStarter.ExtractResume, :sync_stream, 3)
    end
  end

  describe "ElixirStarter module functions" do
    test "extract_resume function exists" do
      # Default args create multiple arities
      exports = ElixirStarter.__info__(:functions)
      assert {:extract_resume, 1} in exports
    end

    test "extract_resume_stream function exists" do
      exports = ElixirStarter.__info__(:functions)
      assert {:extract_resume_stream, 1} in exports or {:extract_resume_stream, 2} in exports
    end

    test "stream_resume_json function exists" do
      exports = ElixirStarter.__info__(:functions)
      assert {:stream_resume_json, 1} in exports
    end
  end
end
