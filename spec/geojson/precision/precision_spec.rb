require "spec_helper"
require "byebug"

RSpec.describe Geojson::Precision do
  it "has a version number" do
    expect(Geojson::Precision::VERSION).not_to be nil
  end

  context("No simplification") do
    let(:parser) { Geojson::Precision::Parser.new(precision: 3) }

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
        feature_in = JSON.parse(fixture_content(:precision, "#{feature}.json"))
        feature_out = JSON.parse(fixture_content(:precision, "#{feature}_expected.json"))
        result = parser.parse(feature_in)
        puts "result #{feature}_expected.json: #{JSON.generate(result)}" if result != feature_out
        expect(result).to eq(feature_out)
      end
    end
  end

  context "With simplification" do
    let(:parser) do
      Geojson::Precision::Parser.new(precision: 3,
                                     simplify:  { tolerance: 5, high_quality: false })
    end

    it "should simplify Polygon" do
      feature_in = JSON.parse(fixture_content(:simplification, "Polygon.json"))
      feature_out = JSON.parse(fixture_content(:simplification, "Polygon_expected.json"))
      result = parser.parse(feature_in)
      puts "result Polygon_expected.json: #{JSON.generate(result)}" if result != feature_out
      expect(result).to eq(feature_out)
    end
  end
end
