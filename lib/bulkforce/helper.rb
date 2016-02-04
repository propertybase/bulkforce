require "csv"

class Bulkforce
  module Helper
    extend self

    ENCODING = "utf-8"

    CSV_OPTIONS = {
      col_sep: ",",
      quote_char: "\"",
      force_quotes: true,
      encoding: ENCODING,
    }

    def records_to_csv records
      file_mock = StringIO.new
      csv_client = CSV.new(file_mock, CSV_OPTIONS)
      all_headers = []
      all_rows = []
      records.each do |hash|
        row = CSV::Row.new([],[],false)
        to_store = hash.inject({}) do |h, (k, v)|
          if v == nil || v == "" || v == []
            h[k] = "#N/A"
          else
            h[k] = v.class == Array ? v.join(";") : v
          end
          h
        end
        row << to_store
        all_headers << row.headers
        all_rows << row
      end
      all_headers.flatten!.uniq!
      csv_client << all_headers
      all_rows.each do |row|
        csv_client << row.fields(*all_headers)
      end
      file_mock.string
    end

    def fetch_instance_from_server_url server_url
      before_sf = server_url[/^https?:\/\/(.+)\.salesforce\.com/, 1]
      before_sf.gsub(/-api$/,"")
    end

    def attachment_keys records
      records.map do |record|
        record.select do |key, value|
          value.class == File
        end.keys
      end.flatten.uniq
    end

    def transform_values! records, keys
      keys.each do |key|
        records.each do |record|
          file_handle = record[key]
          if file_handle
            file_path = File.absolute_path(file_handle)
            record
              .merge!({
                key => Bulkforce::Helper.absolute_to_relative_path(file_path,"#")
              })
            yield file_path if block_given?
          end
        end
      end
    end

    def absolute_to_relative_path input, replacement
      input.gsub(/(^C:[\/\\])|(^\/)/,replacement)
    end

    def parse_csv csv_string
      CSV.parse(csv_string.force_encoding(ENCODING), headers: true).map{|r| r.to_hash}
    end
  end
end
