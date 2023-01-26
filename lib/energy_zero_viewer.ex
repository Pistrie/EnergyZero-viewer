defmodule EnergyZeroViewer do
  def execute do
    data = get_data()
    table = create_table(data)

    IO.puts(table)
  end

  defp get_data do
    # https://api.energyzero.nl/v1/energyprices
    # ?fromDate=2023-01-25T23%3A00%3A00.000Z
    # &tillDate=2023-01-26T22%3A59%3A59.999Z
    # &interval=4
    # &usageType=1
    # &inclBtw=true

    fromDate = DateTime.new!(Date.utc_today(), ~T[00:00:00], "Etc/UTC") |> DateTime.to_iso8601()
    tillDate = DateTime.new!(Date.utc_today(), ~T[23:59:59], "Etc/UTC") |> DateTime.to_iso8601()

    default_parameters = %{
      fromDate: fromDate,
      tillDate: tillDate,
      interval: 4,
      usageType: 1,
      inclBtw: true
    }

    energy_url = "https://api.energyzero.nl/v1/energyprices"
    result = HTTPoison.get!(energy_url, [], params: default_parameters)
    JSON.decode!(result.body)
  end

  defp create_table(energy_data) do
    {:ok, fromDate, _} = Map.get(energy_data, "fromDate") |> DateTime.from_iso8601()
    title = "#{Calendar.strftime(fromDate, "%d %B %Y")}"
    header = ["price", "time"]
    data = Map.get(energy_data, "Prices")

    rows =
      Enum.map(data, fn data_point ->
        price = Map.get(data_point, "price")
        {:ok, time, _} = Map.get(data_point, "readingDate") |> DateTime.from_iso8601()

        [
          time.hour,
          price |> Float.round(2)
        ]
      end)

    TableRex.quick_render!(rows, header, title)
  end
end
