require 'minitest/autorun'

require_relative './map'
require_relative '../22/dijkstra'
require_relative './game'

describe Game do
  it "test n" do
    game = Game.new(<<~GRID)
      #######
      #.G...#
      #...EG#
      #.#.#G#
      #..G#E#
      #.....#
      #######
    GRID

    game.play { false }
    assert_equal [47, 590, 27730], game.outcome
  end

  it "test n" do
    game = Game.new(<<~GRID)
      #######
      #G..#E#
      #E#E.E#
      #G.##.#
      #...#E#
      #...E.#
      #######
    GRID

    game.play { false }
    assert_equal [37, 982, 36334], game.outcome
  end

  it "test n" do
    game = Game.new(<<~GRID)
      #######
      #E..EG#
      #.#G.E#
      #E.##E#
      #G..#.#
      #..E#.#
      #######
    GRID

    game.play { false }
    assert_equal [46, 859, 39514], game.outcome
  end

  it "test n" do
    game = Game.new(<<~GRID)
      #######
      #E.G#.#
      #.#G..#
      #G.#.G#
      #G..#.#
      #...E.#
      #######
    GRID

    game.play { false }
    assert_equal [35, 793, 27755], game.outcome
  end

  it "test n" do
    game = Game.new(<<~GRID)
      #######
      #.E...#
      #.#..G#
      #.###.#
      #E#G#G#
      #...#G#
      #######
    GRID

    game.play { false }
    assert_equal [54, 536, 28944], game.outcome
  end

  it "test n" do
    game = Game.new(<<~GRID)
      #########
      #G......#
      #.E.#...#
      #..##..G#
      #...##..#
      #...#...#
      #.G...G.#
      #.....G.#
      #########
    GRID

    game.play { false }
    assert_equal [20, 937, 18740], game.outcome
  end
end
