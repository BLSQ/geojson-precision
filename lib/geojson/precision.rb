require "geojson/precision/version"

module Geojson
  module Precision

    class Parser

            def initialize(precision)
              @precision = precision
            end

            def parse(geojson)
              case t.type
              when "Feature"
                  return feature(t)
                when "GeometryCollection"
                  return geometryCollection(t)
                when "FeatureCollection"
                  return featureCollection(t)
                when "Point","LineString", "Polygon", "MultiPoint", "MultiPolygon", "MultiLineString"
                  return geometry(t)
                else
                  return t
                end
            end

            private

                def point(p)
                   p.map do |e|
                     1 * e.toFixed(precision);
                  end
                end

                def multi(l)
                   l.map(point);
                end

                def poly(p)
                   p.map{|m|multi(m)};
                end

                def multi_poly(m)
                   m.map {|p|poly(p)};
                end

                def geometry(obj) {

                  case obj.type
                    when "Point"
                      obj.coordinates = point(obj.coordinates);
                      return obj;
                    when "LineString"
                    when "MultiPoint"
                      obj.coordinates = multi(obj.coordinates);
                      return obj;
                    when "Polygon"
                    when "MultiLineString"
                      obj.coordinates = poly(obj.coordinates);
                      return obj;
                    when "MultiPolygon"
                      obj.coordinates = multiPoly(obj.coordinates);
                      return obj;
                    when "GeometryCollection"
                      obj.geometries = obj.geometries.map(geometry);
                      return obj;
                    else
                      return {};
                    end
              end

              def feature(obj) {
                obj.geometry = geometry(obj.geometry)
                obj
              end

              def feature_collection(f) {
                f.features = f.features.map(feature)
                f
              end

                def geometry_collection(g)
                  g.geometries = g.geometries.map(geometry)
                  g
                end
        end
  end
end
