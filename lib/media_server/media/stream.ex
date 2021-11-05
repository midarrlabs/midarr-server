defmodule MediaServer.Media.Stream do
    use Membrane.Pipeline

    @impl true
    def handle_init(path_to_file) do

        children = %{
            file: %Membrane.File.Source{location: path_to_file},
            # raw: %Membrane.Element.RawVideo.Parser{
            #     format: :I420,
            #     width: 1920,
            #     height: 1080
            # },
            parser: %Membrane.H264.FFmpeg.Parser{
                framerate: {30, 1},
                alignment: :au,
                attach_nalus?: true
            },
            # decoder: Membrane.H264.FFmpeg.Decoder,
            # encoder: Membrane.H264.FFmpeg.Encoder,
            payload: Membrane.MP4.Payloader.H264,
            muxer: Membrane.MP4.Muxer.CMAF,
            sink: %Membrane.HTTPAdaptiveStream.Sink{
                manifest_module: Membrane.HTTPAdaptiveStream.HLS,
                storage: %Membrane.HTTPAdaptiveStream.Storages.FileStorage{
                    directory: "/app/priv/static/test"
                }
            }
        }

        links = [
            link(:file)
            # |> to(:raw)
            |> to(:parser)
            # |> to(:decoder)
            # |> to(:encoder)
            |> to(:payload)
            |> to(:muxer)
            |> to(:sink)
        ]

        spec = %ParentSpec{
            children: children,
            links: links
        }

        {{:ok, spec: spec}, %{}}
    end

    # @impl true
    # def handle_notification(:end_of_stream, :sink, _context, state) do
    #     Membrane.Pipeline.stop_and_terminate(self())
    #     {:ok, state}
    # end

    # def handle_notification(_notification, _element, state) do
    #     {:ok, state}
    # end
end