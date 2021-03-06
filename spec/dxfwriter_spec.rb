require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'dxf/writer'

describe DXF::Writer do
  it "draws a line" do
    file = "line.dxf"
    dw = DXF::Writer.new(file)
    dw.entities.line(2, 2, 5, 8)
    dw.finish
    File.exist?(file).should be_true
    File.size(file).should > 0
  end

  it "draws a polyline" do
    file = "polyline.dxf"
    dw = DXF::Writer.new(file)
    dw.entities.lwpolyline([[2,1], [1,4], [5,5], [6,2]])
    dw.entities.lwpolyline([[9,3], [7,5], [9,7], [11,5]], :close => true)
    dw.finish
    File.exist?(file).should be_true
    File.size(file).should > 0
  end

  it "draws curvy entities" do
    file = "curvy.dxf"
    dw = DXF::Writer.new(file)
    e = dw.entities
    e.circle(3, 3, 2)
    e.arc(7, 3, 3, 10, 140)
    e.point(7, 3)
    e.ellipse(4, -1, -3, 1, 0.3)
    e.point(10, 0)
    e.ellipse(10, 0, 4, 0, 0.25, 90, 180)
    dw.finish
    File.exist?(file).should be_true
    File.size(file).should > 0
  end

  it "has layers with linetypes" do
    file = "layers.dxf"
    dw = DXF::Writer.new(file)
    e = dw.entities

    e.layer = DXF::Layer.new('First', DXF::Linetype.dashdot)
    e.line(2, 2, 5, 8)

    e.layer = DXF::Layer.new('Second', DXF::Linetype.center, :color => 2,
                             :locked => true)
    e.lwpolyline([[2,1], [1,4], [5,5], [6,2]])

    e.layer = DXF::Layer.new('Third', DXF::Linetype.border, :color => 3,
                             :visible => false, :frozen => true)
    e.lwpolyline([[9,3], [7,5], [9,7], [11,5]], :close => true)

    dw.finish
    File.exist?(file).should be_true
    File.size(file).should > 0
  end
end
