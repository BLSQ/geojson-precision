require "spec_helper"
require "byebug"

RSpec.describe Geojson::Precision do
  Parser = Geojson::Precision::Parser
  it "has a version number" do
    expect(Geojson::Precision::VERSION).not_to be nil
  end

  {
    precision:      Parser.new(precision: 3),
    simplification: Parser.new(precision: 3,
                               simplify:  { tolerance: 5, high_quality: false })
  }.each do |with_option, parser|

    context(" with " + with_option.to_s) do
      %w[Point
         FeaturePoint
         Polygon
         HolyPolygon
         MultiPoint
         MultiPolygon
         MultiLineString
         FeatureCollection
         FeatureCollectionFull
         GeometryCollection
         FeatureCollectNoGeo
         InvalidObject].each do |feature|

        it "should map #{feature}" do
          specific_fixture_exist = File.exist?(fixture_file(with_option, "#{feature}.json"))
          feature_in = JSON.parse(
            fixture_content(
              specific_fixture_exist ? with_option : :precision,
              "#{feature}.json"
            )
          )
          result = parser.parse(feature_in)

          feature_out = load_or_create_expected(with_option, feature, result)

          puts "result #{feature}_expected.json: #{JSON.generate(result)}" if result != feature_out

          expect(result).to eq(feature_out)
        end

        def load_or_create_expected(with_option, feature, result)
          feature_out_file = fixture_file(with_option, "#{feature}_expected.json")
          unless File.exist?(feature_out_file)
            puts "creating #{feature_out_file}"
            File.open(feature_out_file, "w") { |file| file.write(JSON.pretty_generate(result)) }
          end
          JSON.parse(File.read(feature_out_file))
        end
      end
    end
  end
end
