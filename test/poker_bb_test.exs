defmodule PokerBbTest do
  # the different possible hands
  def straightFlush do
    ["7S", "3S", "4S", "5S", "6S"]
  end
  def straight do
    ["AD", "JS", "QC", "TH", "KS"]
  end
  def flush do
    ["JD", "7D", "9D", "AD", "2D"]
  end
  def three do
    ["KD", "KS", "KC", "AH", "QS"]
  end
  def fullHouse do
    ["6D", "6S", "6C", "4H", "4S"]
  end
  def pair do
  ["6D", "6S", "7C", "5H", "8S"]
  end
  def twoPair do
    ["TD", "TS", "QC", "QH", "JS"]
  end
  def four do
  ["5D", "5S", "5C", "5H", "JS"]
  end
  def high do
  ["3D", "7S", "KC", "5H", "JS"]
  end
  def straightFlush2 do
    ["2S", "3S", "4S", "5S", "6S"]
  end
  def straight2 do
    ["9D", "JS", "QC", "TH", "KS"]
  end
  def flush2 do
    ["JD", "7D", "9D", "KD", "2D"]
  end
  def three2 do
    ["JD", "JS", "JC", "AH", "9S"]
  end
  def fullHouse2 do
    ["5D", "5S", "5C", "4H", "4S"]
  end
  def pair2 do
    ["5D", "5S", "7C", "2H", "8S"]
  end
  def pair3 do
    ["6D", "6S", "7C", "4H", "8S"]
  end
  def twoPair2 do
    ["TD", "TS", "JC", "JH", "5S"]
  end
  def twoPair3 do
    ["TD", "TS", "QC", "QH", "5S"]
  end
  def twoPair4 do
    ["5D", "5S", "QC", "QH", "JS"]
  end
  def four2 do
    ["4D", "4S", "4C", "4H", "JS"]
  end
  def high2 do
    ["3S", "5D", "KS", "9D", "TC"]
  end
  def high3 do
    ["2D", "7S", "KC", "5H", "JS"]  
  end
 



  use ExUnit.Case
  #doctest PokerBb


#test both hand have different combination, no tie 
  test "straightFlush against four" do
    assert PokerBb.winner(straightFlush(),four()) == {1,"straight flush"}
  end
  test "four of a kind against fullHouse" do
    assert PokerBb.winner(four(),fullHouse()) == {1,"four of a kind"}
  end
  test "fullHouse against flush" do
    assert PokerBb.winner(fullHouse(),flush()) == {1,"full house"}
  end
  test "flush against straight" do
    assert PokerBb.winner(flush(),straight()) == {1,"flush"}
  end
  test "straight against three of a kind" do
    assert PokerBb.winner(straight(),three()) == {1,"straight"}
  end
  test "three against two pairs" do
    assert PokerBb.winner(three(),twoPair()) == {1,"three of a kind"}
  end
  test "two pairs against pair" do
    assert PokerBb.winner(twoPair(),pair()) == {1,"two pairs"}
  end
  test "pair against high card" do
    assert PokerBb.winner(pair(),high()) == {1,"pair"}
  end

#test tie breaker
test "straightFlush tiebreaker" do
  assert PokerBb.winner(straightFlush(),straightFlush2()) == {1,"high card:","7"}
end
test "four tiebreaker" do
  assert PokerBb.winner(four(),four2()) == {1,"high card:","5"}
end
test "fullHouse tiebreaker" do
  assert PokerBb.winner(fullHouse(),fullHouse2()) =={1,"high card:","6"}
end
test "flush tiebreaker" do
  assert PokerBb.winner(flush(),flush2()) == {1,"high card:","Ace"}
end
test "straight tiebreaker" do
  assert PokerBb.winner(straight(),straight2()) == {1,"high card:","Ace"}
end
test "three of a kind tiebreaker" do
  assert PokerBb.winner(three(),three2()) == {1,"high card:","King"}
end
test "two pairs tiebreaker if both hands have two pairs, first hand has higher first pair" do
  assert PokerBb.winner(twoPair(),twoPair2()) == {1,"high card:","Queen"}
end
test "two pairs tiebreaker if both hands have two pairs with same cards for both pairs" do
  assert PokerBb.winner(twoPair(),twoPair3()) == {1,"high card:","Jack"}
end
test "two pairs tiebreaker if both hands have two pairs with same cards for first pair" do
  assert PokerBb.winner(twoPair(),twoPair4()) == {1,"high card:","10"}
end
test "pair tiebreaker if both hands have a pair, first hand  has highed pair" do
  assert PokerBb.winner(pair(),pair2()) == {1,"high card:","6"}
end
test "pair tiebreaker if both hands have a pair with same value, two higher cards equal, only the 5th card is different" do
  assert PokerBb.winner(pair(),pair3()) == {1,"high card:","5"}
end
test "high card tiebreaker, first card is the same" do
  assert PokerBb.winner(high(),high2()) == {1,"high card:","Jack"}
end
test "high card tiebreaker, all cards are the same except last one" do
  assert PokerBb.winner(high(),high3()) == {1,"high card:","3"}
end

#test draw
test "both hands identical, straightFlush" do
  assert PokerBb.winner(straightFlush(),straightFlush()) == {3}
end
test "both hands identical, high card" do
  assert PokerBb.winner(high(),high()) == {3}
end


test "greets the world" do
  assert PokerBb.test() == :tata
end
end

