defmodule MediaServer.MediaProducerTest do
  use ExUnit.Case

  test "it should process" do
    {:ok, producer_pid} = MediaServer.MediaProducer.start_link(Enum.map(1..2000, &%{"title" => "Title #{&1}"}))
    {:ok, consumer_pid} = MediaServer.MovieConsumer.start_link()

    {:ok, _subscription_tag} = GenStage.sync_subscribe(consumer_pid, to: producer_pid)

    # Wait for the consumer to process items
    Process.sleep(500)

    assert length(MediaServer.MovieConsumer.all()) == 1000
  end

  test "it should all" do
    {:ok, producer_pid} = MediaServer.MediaProducer.start_link([
      %{"id" => 1, "title" => "Some Title"},
      %{"id" => 2, "title" => "Another Title"}
      ])
    {:ok, consumer_pid} = MediaServer.MovieConsumer.start_link()

    {:ok, _subscription_tag} = GenStage.sync_subscribe(consumer_pid, to: producer_pid)

    # Wait for the consumer to process movies
    Process.sleep(500)

    assert MediaServer.MovieConsumer.all() ==
      [
        %{id: 1, title: "Some Title"},
        %{id: 2, title: "Another Title"}
      ]
  end

  test "it should find" do
    {:ok, producer_pid} = MediaServer.MediaProducer.start_link([
      %{"id" => 1, "title" => "Some Title"},
      %{"id" => 2, "title" => "Another Title"}
      ])
    {:ok, consumer_pid} = MediaServer.MovieConsumer.start_link()

    {:ok, _subscription_tag} = GenStage.sync_subscribe(consumer_pid, to: producer_pid)

    # Wait for the consumer to process movies
    Process.sleep(500)

    assert MediaServer.MovieConsumer.find(1) == %{id: 1, title: "Some Title"}
  end

  test "it should search" do
    {:ok, producer_pid} = MediaServer.MediaProducer.start_link([
      %{"id" => 1, "title" => "Some Title"},
      %{"id" => 2, "title" => "Another Title"}
      ])
    {:ok, consumer_pid} = MediaServer.MovieConsumer.start_link()

    {:ok, _subscription_tag} = GenStage.sync_subscribe(consumer_pid, to: producer_pid)

    # Wait for the consumer to process movies
    Process.sleep(500)

    assert MediaServer.MovieConsumer.search("Some") == [%{id: 1, title: "Some Title"}]
  end
end
