defmodule MediaServer.PaginateTest do
  use ExUnit.Case

  @languages [
    "C#",
    "C++",
    "Clojure",
    "Elixir",
    "Erlang",
    "Go",
    "JAVA",
    "JavaScript",
    "Lisp",
    "PHP",
    "Perl",
    "Python",
    "Ruby",
    "Rust",
    "SQL"
  ]
  @total_entries length(@languages)
  @config %Scrivener.Config{page_number: 2, page_size: 4}

  describe "paginate without using a repo module" do
    test "can paginate a list when passed a Scrivener.Config. t directly - 1" do
      page = Scrivener.paginate(@languages, @config)

      assert page.page_number == 2
      assert page.page_size == 4
      assert page.entries == ["Erlang", "Go", "JAVA", "JavaScript"]
      assert page.total_entries == @total_entries
      assert page.total_pages == Float.ceil(length(@languages) / 4)
    end

    test "can paginate a list when passed a Scrivener.Config. t directly - 2" do
      languages = Enum.take(@languages, 3)
      page = Scrivener.paginate(languages, @config)

      assert page.page_number == 2
      assert page.page_size == 4
      assert page.entries == []
      assert page.total_entries == 3
      assert page.total_pages == Float.ceil(length(languages) / 4)
    end

    test "can paginate a list when provided the current page and page size as a params map" do
      page = Scrivener.paginate(@languages, %{"page" => "2", "page_size" => "3"})

      assert page.page_size == 3
      assert page.page_number == 2
      assert page.entries == ["Elixir", "Erlang", "Go"]
      assert page.total_entries == @total_entries
      assert page.total_pages == Float.ceil(length(@languages) / 3)
    end

    test "can paginate a list when provided the current page and page size as a keyword list" do
      page = Scrivener.paginate(@languages, page: 2, page_size: 3)

      assert page.page_size == 3
      assert page.page_number == 2
      assert page.entries == ["Elixir", "Erlang", "Go"]
      assert page.total_pages == Float.ceil(length(@languages) / 3)
      assert page.total_entries == @total_entries
    end

    test "can paginate a list when only provided with the page size as a keyword list
        and the page number defaults to page 1" do
      page = Scrivener.paginate(@languages, page_size: 3)

      assert page.page_size == 3
      assert page.page_number == 1
      assert page.entries == ["C#", "C++", "Clojure"]
      assert page.total_pages == Float.ceil(length(@languages) / 3)
      assert page.total_entries == @total_entries
    end

    test "can paginate a list when only provided with the page number as a keyword list
        and the page size defaults to 10" do
      page = Scrivener.paginate(@languages, page: 2)

      assert page.page_size == 10
      assert page.page_number == 2
      assert page.entries == ["Perl", "Python", "Ruby", "Rust", "SQL"]
      assert page.total_pages == Float.ceil(length(@languages) / 10)
      assert page.total_entries == @total_entries
    end

    test "can paginate a list when provided the current page and page size is absent" do
      page = Scrivener.paginate(@languages, page: 2)

      assert page.page_size == 10
      assert page.page_number == 2
      assert page.entries == ["Perl", "Python", "Ruby", "Rust", "SQL"]
      assert page.total_pages == Float.ceil(length(@languages) / 10)
      assert page.total_entries == @total_entries
    end

    test "cannot respect a max_page_size configuration" do
      page = Scrivener.paginate(@languages, page: 2, page_size: 200)

      refute page.page_size < 200
      assert page.page_number == 2
      assert page.entries == []
      assert page.total_pages == Float.ceil(length(@languages) / 200)
      assert page.total_entries == @total_entries
    end
  end
end