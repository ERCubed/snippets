require 'net/http'
require 'uri'
require 'nokogiri'

doc_url = 'https://docs.google.com/document/d/e/2PACX-1vTER-wL5E8YC9pxDx43gk8eIds59GtUUk4nJo_ZWagbnrH0NFvMXIw6VWFLpf5tWTZIT9P9oLIoFJ6A/pub'

def extract_grid_from_doc(doc_url)
  url = URI.parse(doc_url)
  response = Net::HTTP.get_response(url)

  if response.is_a?(Net::HTTPSuccess)
    content = response.body
    doc = Nokogiri::HTML(content)
    table = doc.at('table')

    table_data = get_table_values(table)

    print_table_data_message(table_data)
  else
    puts "Error: #{response.code} - #{response.message}" 
    return
  end
end

def get_table_values(table)
    table_data = []
    # Iterate over each row in the table
    table.css('tr').each do |row|
      row_data = []
      # Iterate over each cell (header or data) in the row
      row.css('th, td').each do |cell|
        row_data << cell.text.strip
      end
      table_data << row_data
    end

    # create the array of hashes for the message
    header = table_data.shift
    message = []
    table_data.each do |data|
        message << {
                     header[0] => data[0].to_i,
                     header[1] => data[1],
                     header[2] => data[2].to_i
                   }
    end

    message
end

def print_table_data_message(table_data)
    max_x = table_data.max_by { |td| td['x-coordinate'] }['x-coordinate']
    max_y = table_data.max_by { |td| td['y-coordinate'] }['y-coordinate']
    
    grid = Array.new(max_y + 1) { Array.new(max_x + 1, ' ') }
    table_data.each do |data|
        grid[data['y-coordinate']][data['x-coordinate']] = data['Character']
    end

    grid.each do |row|
      puts row.join
    end
end

extract_grid_from_doc(doc_url)