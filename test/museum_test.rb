require 'minitest/autorun'
require 'minitest/pride'
require './lib/museum'
require './lib/patron'
require './lib/exhibit'
require 'mocha/minitest'

class MuseumTest < Minitest::Test

  def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")
    @patron_1 = Patron.new("Bob", 0)
    @patron_2 = Patron.new("Sally", 20)
    @patron_3 = Patron.new("Johnny", 5)
  end

  def test_it_exists
    assert_instance_of Museum, @dmns
  end

  def test_it_has_attributes
    assert_equal "Denver Museum of Nature and Science", @dmns.name
    assert_equal [], @dmns.exhibits
  end

  def test_it_can_add_exhibits
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    @dmns.add_exhibit(gems_and_minerals)
    @dmns.add_exhibit(dead_sea_scrolls)
    @dmns.add_exhibit(imax)
    expected = [gems_and_minerals, dead_sea_scrolls, imax]
    assert_equal expected, @dmns.exhibits
  end

  def test_it_can_add_patrons
    assert_equal [], @dmns.patrons
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    assert_equal [@patron_1, @patron_2], @dmns.patrons
  end

  def test_it_can_recommend_exhibits_based_on_interest
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    @dmns.add_exhibit(gems_and_minerals)
    @dmns.add_exhibit(dead_sea_scrolls)
    @dmns.add_exhibit(imax)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("IMAX")
    expected_1 = [gems_and_minerals, dead_sea_scrolls]
    expected_2 = [imax]
    assert_equal expected_1, @dmns.recommend_exhibits(@patron_1)
    assert_equal expected_2, @dmns.recommend_exhibits(@patron_2)
  end

  def test_it_can_list_patron_exhibit_interest
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    @dmns.add_exhibit(gems_and_minerals)
    @dmns.add_exhibit(dead_sea_scrolls)
    @dmns.add_exhibit(imax)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    expected = {
      gems_and_minerals => [@patron_1],
      dead_sea_scrolls => [@patron_1, @patron_2, @patron_3],
    }
    assert_equal expected, @dmns.patron_exhibit_interests
  end

  def test_it_can_list_patrons_by_exhibit_interest
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    @dmns.add_exhibit(gems_and_minerals)
    @dmns.add_exhibit(dead_sea_scrolls)
    @dmns.add_exhibit(imax)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    expected = {
      gems_and_minerals => [@patron_1],
      dead_sea_scrolls => [@patron_1, @patron_2, @patron_3],
      imax => []
    }
    assert_equal expected, @dmns.patrons_by_exhibit_interest
  end

  def test_it_can_return_lottery_contestants_for_exhibit
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    @dmns.add_exhibit(gems_and_minerals)
    @dmns.add_exhibit(dead_sea_scrolls)
    @dmns.add_exhibit(imax)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    expected = [@patron_1, @patron_3]
    assert_equal expected, @dmns.ticket_lottery_contestants(dead_sea_scrolls)
  end

  def test_it_can_draw_a_loterry_winner
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    @dmns.add_exhibit(gems_and_minerals)
    @dmns.add_exhibit(dead_sea_scrolls)
    @dmns.add_exhibit(imax)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    assert_equal nil, @dmns.draw_lottery_winner(gems_and_minerals)
    @dmns.stubs(:ticket_lottery_contestants).returns([@patron_3])
    assert_equal "Johnny", @dmns.draw_lottery_winner(dead_sea_scrolls)
  end

  def test_it_can_announce_a_lottery_winner
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    @dmns.add_exhibit(gems_and_minerals)
    @dmns.add_exhibit(dead_sea_scrolls)
    @dmns.add_exhibit(imax)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    expected = "Bob has won the IMAX exhibit lottery"
    assert_equal "No winners for this lottery", @dmns.announce_lottery_winner(gems_and_minerals)
    @dmns.stubs(:ticket_lottery_contestants).returns([@patron_1])
    assert_equal expected, @dmns.announce_lottery_winner(imax)
  end

  def test_it_can_subtract_money_from_patron_after_attending_exhibit
    skip
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    @dmns.add_exhibit(gems_and_minerals)
    @dmns.add_exhibit(dead_sea_scrolls)
    @dmns.add_exhibit(imax)
    tj = Patron.new("TJ", 7)
    patron_1 = Patron.new("Bob", 10)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    @dmns.admit(tj)
    patron_1.add_interest("Dead Sea Scrolls")
    patron_1.add_interest("IMAX")
    @dmns.admit(patron_1)
    assert_equal 7, tj.spending_money
    assert_equal 10, patron_1.spending_money
  end

  def test_patrons_attend_exhibits_they_are_interested_in_and_can_afford
    skip 
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    imax = Exhibit.new({name: "IMAX",cost: 15})
    @dmns.add_exhibit(gems_and_minerals)
    @dmns.add_exhibit(dead_sea_scrolls)
    @dmns.add_exhibit(imax)
    tj = Patron.new("TJ", 7)
    patron_1 = Patron.new("Bob", 10)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    @dmns.admit(tj)
    patron_1.add_interest("Dead Sea Scrolls")
    patron_1.add_interest("IMAX")
    @dmns.admit(patron_1)
    assert_equal [], tj.exhibits_attended
    assert_equal [dead_sea_scrolls], patron1.exhibit_interests
  end



end
