require "geojson/precision/version"
require "json"

module Geojson
  module Precision
    class Parser
      def initialize(precision)
        @precision = precision
      end

      def parse(geojson)
        case geojson["type"]
        when "Feature"
          feature(geojson)
        when "GeometryCollection"
          geometry_collection(geojson)
        when "FeatureCollection"
          feature_collection(geojson)
        when "Point", "LineString", "Polygon", "MultiPoint", "MultiPolygon", "MultiLineString"
          return geometry(geojson)
        else
          geojson
        end
      end

      private

      attr_reader :precision

      def point(p)
        p.map do |e|
          e.round(precision)
        end
      end

      def multi(l)
        l.map { |l| point(l) }
      end

      def poly(p)
        p.map { |m| multi(m) }
      end

      def multi_poly(m)
        m.map { |p| poly(p) }
      end

      def geometry(obj)
        return nil unless obj
        case obj["type"]
        when "Point"
          obj["coordinates"] = point(obj["coordinates"])
        when "LineString", "MultiPoint"
          obj["coordinates"] = multi(obj["coordinates"])
        when "Polygon", "MultiLineString"
          obj["coordinates"] = poly(obj["coordinates"])
        when "MultiPolygon"
          obj["coordinates"] = multi_poly(obj["coordinates"])
        when "GeometryCollection"
          obj["geometries"] = obj["geometries"].map { |g| geometry(g) }
        end
        obj
      end

      def feature(obj)
        obj["geometry"] = geometry(obj["geometry"])
        obj
      end

      def feature_collection(f)
        f["features"] = f["features"].map { |fe| feature(fe) }
        f
      end

      def geometry_collection(g)
        g["geometries"] = g["geometries"].map { |ge| geometry(ge) }
        g
      end
    end
  end
end
