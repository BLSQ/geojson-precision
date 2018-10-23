require "geojson/precision/version"
require "simplify_rb"
require "json"

module Geojson
  module Precision
    class Parser
      def initialize(options = { precision: 6, simplify: {} })
        @precision = options[:precision]
        @simplify_options = options[:simplify]
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

      attr_reader :precision, :simplify_options

      def point(p)
        p.map do |e|
          e.round(precision)
        end
      end

      def multi(l)
        l.map { |l| point(l) }
      end

      def poly(poly_obj)
        coords = poly_obj.map { |m| multi(m) }
        return simplify(coords) if simplify_options

        coords
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

      def simplify(coordinates)
        coord = coordinates[0].map { |c| { x: c[0], y: c[1] } }
        processed_coord = simplifier.process(coord,
                                             simplify_options[:tolerance],
                                             simplify_options[:high_quality])
        [processed_coord.map { |c| [c[:x], c[:y]] }]
      end

      def simplifier
        @simplifier ||= SimplifyRb::Simplifier.new
      end
    end
  end
end
