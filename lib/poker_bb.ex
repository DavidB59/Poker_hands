defmodule PokerBb do
  # calculate the number of cards having a given suit in a hand
  def suitCount(hand, suit) do
    Enum.count(hand, fn x -> String.at(x, 1) === suit end)
  end

  # Return true if the hand is flush
  def flush(hand) do
    suits = ["C", "D", "H", "S"]
    result = Enum.filter(suits, fn x -> suitCount(hand, x) == 5 end)

    cond do
      Enum.at(result, 0) -> true
      !Enum.at(result, 0) -> false
    end
  end

  # give the index corresponding to the rank of a card
  # A -> 14, K ->  13 , Q -> 12... , 3 -> 2 , 2 -> 1
  def cardPower(card) do
    order = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
    Enum.find_index(order, fn x -> String.at(card, 0) == x end)
  end

  # give the type of cards corresponding to its index from the cardPower function
  def whichCard(index) do
    name = [
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "Jack",
      "Queen",
      "King",
      "Ace"
    ]

    Enum.at(name, index)
  end

  # return the hand sorted from the strongest card to the weakest card
  def sorting(hand) do
    Enum.sort(hand, &(cardPower(&1) >= cardPower(&2)))
  end

  # Transform the hand into a list of number ranked from strongest to weakest 
  def cardsByPower(hand) do
    sorting(hand) |> Enum.map(fn x -> cardPower(x) end)
  end

  # Return true if the hand is straight
  def straight(hand) do
    [a, b, c, d, e] = cardsByPower(hand)
    a - b === b - c and c - d === d - e and a - b === 1 and c - d === 1
  end

  # take out cards that aren't present more than once ouf out the hand - must be called on cardsByPower(hand)
  def removing(hand) do
    one = Enum.dedup(hand)
    hand -- one
  end

  # Return rank of the hand if neither straight nor flush
  def handPowerNoColour(hand) do
    hand = cardsByPower(hand)

    # case length(removing(hand)) do
    case removing(hand) |> length do
      0 ->
        # IO.puts("high card")
        1

      1 ->
        # IO.puts("one pair")
        2

      2 ->
        # case length(removing(removing(hand))) do
        case removing(hand) |> removing |> length do
          1 ->
            # IO.puts("three of a kind")
            4

          0 ->
            # IO.puts("two pairs")
            3

          _ ->
            IO.puts("error")
        end

      3 ->
        # case length(removing(removing(hand))) do
        case removing(hand) |> removing |> length do
          1 ->
            # IO.puts("full house")
            7

          2 ->
            # IO.puts("four of a kind")
            8

          _ ->
            IO.puts("error")
        end

      _ ->
        IO.puts("error")
    end
  end

  # Return rank of the hand as an integer
  # 1 for high card,  2 for pair, 3 for two pairs, 4 for three of a kind
  # 5 for  straight, 6 for flush, 7 for full house, 8 for four of a kind
  # 9 for straight flush 
  def handPower(hand) do
    cond do
      flush(hand) and straight(hand) ->
        # IO.puts("Straight flush")
        9

      flush(hand) ->
        # IO.puts("flush")
        6

      straight(hand) ->
        # IO.puts("straight")
        5

      true ->
        handPowerNoColour(hand)
    end
  end

  # give the type of hand corresponding to its index from the handPower
  def whichHand(index) do
    name = [
      "index0",
      "high card",
      "pair",
      "two pairs",
      "three of a kind",
      "straight",
      "flush",
      "full house",
      "four of a kind",
      "straight flush"
    ]

    Enum.at(name, index)
  end

  # compare the cards of both hand one by one - must be called on ordered hands ( cardsByPower)
  # return 1 if hand1 wins, 2 if hand2 wins, 3 if it's a tie
  def tieBreaker(hand1, hand2, index) do
    cond do
      Enum.at(hand1, index) > Enum.at(hand2, index) ->
        {1, "high card:", Enum.at(hand1, index) |> whichCard}

      Enum.at(hand1, index) < Enum.at(hand2, index) ->
        {2, "high card:", Enum.at(hand2, index) |> whichCard}

      index > length(hand1) ->
        {3}

      true ->
        tieBreaker(hand1, hand2, index + 1)
    end
  end

  # return 1 if hand1 wins, 2 if hand2 wins, 3 if it's a tie
  def winner(hand1, hand2) do
    cond do
      handPower(hand1) > handPower(hand2) ->
        {1, handPower(hand1) |> whichHand}

      handPower(hand1) < handPower(hand2) ->
        {2, handPower(hand2) |> whichHand}

      handPower(hand1) == handPower(hand2) ->
        hand1_ordered = cardsByPower(hand1)
        hand2_ordered = cardsByPower(hand2)

        case handPower(hand1) do
          # tie breaker for high card
          1 ->
            tieBreaker(hand1_ordered, hand2_ordered, 0)

          # tie breaker for one pair
          2 ->
            valuePair1 = hand1_ordered |> removing |> List.first()
            valuePair2 = hand2_ordered |> removing |> List.first()

            cond do
              valuePair1 > valuePair2 ->
                {1, "high card:", whichCard(valuePair1)}


              valuePair1 < valuePair2 ->
                {2, "high card:", whichCard(valuePair2)}


              valuePair1 === valuePair2 ->
                tieBreaker(hand1_ordered, hand2_ordered, 0)
            end

          # tie breaker for two pairs
          3 ->
            [head1 | tail1] = hand1_ordered |> removing
            [head2 | tail2] = hand2_ordered |> removing
            cond do
              head1 > head2 ->
                {1, "high card:", whichCard(head1)}


              head1 < head2 ->
                {2, "high card:", whichCard(head2)}


              head1 === head2 ->
                cond do
                  tail1 > tail2 ->
                    {1, "high card:", whichCard(Enum.at(tail1,0))}


                  tail1 < tail2 ->
                    {2, "high card:", whichCard(Enum.at(tail2,0))}



                  tail1 === tail2 ->
                    tieBreaker(hand1_ordered, hand2_ordered, 0)
                end
            end

          # tie breaker for three of a kind
          4 ->
            valueTriplet1 = hand1_ordered |> removing |> List.first()
            valueTriplet2 = hand2_ordered |> removing |> List.first()

            cond do
              valueTriplet1 > valueTriplet2 ->
                {1, "high card:", whichCard(valueTriplet1)}


              valueTriplet1 < valueTriplet2 ->
                {2, "high card:", whichCard(valueTriplet2)}


              valueTriplet1 === valueTriplet2 ->
                {3}

              true ->
                IO.puts("error")
            end

          # tie breaker for straight
          5 ->
            tieBreaker(hand1_ordered, hand2_ordered, 0)

          # tie breaker for flush
          6 ->
            tieBreaker(hand1_ordered, hand2_ordered, 0)

          # tie breaker for full house
          7 ->
            valueTriplet1 = hand1_ordered |> removing |> removing |> List.first()
            valueTriplet2 = hand2_ordered |> removing |> removing |> List.first()

            cond do
              valueTriplet1 > valueTriplet2 ->
                {1, "high card:", whichCard(valueTriplet1)}


              valueTriplet1 < valueTriplet2 ->
                {2, "high card:", whichCard(valueTriplet2)}


              valueTriplet1 === valueTriplet2 ->
                {3}

              true ->
                IO.puts("error")
            end

          # tie breaker for four of a kind
          8 ->
            tieBreaker(hand1_ordered |> removing, hand2_ordered |> removing, 0)

          # tie breaker for straight flush
          9 ->
            tieBreaker(hand1_ordered, hand2_ordered, 0)

          _ ->
            3
        end

      true ->
        3
    end
  end

  def takeInput do
    IO.puts("follow the format Black: 2H 3D 5S 9C KD White: 2D 3H 5C 9S KH")
    input = IO.gets("")
    list = String.split(input)
    # IO.puts(input)
    # IO.puts(list)
    case length(list) do
      12 ->
        {black, white} = Enum.split(list, 6)
        {_color1, hand1} = Enum.split(black, 1)
        {_color2, hand2} = Enum.split(white, 1)
        #IO.puts(black)
        #IO.puts(white)
        winner(hand1, hand2)

      _ ->
        IO.puts("format not respected")
    end
  end

  def output do
    a = takeInput()

    case elem(a, 0) do
      1 ->
        case tuple_size(a) do
          2->
            "Black wins - #{elem(a, 1)}"
          3->
            "Black wins - #{elem(a, 1)} #{elem(a, 2)}"
        end

      2 ->
        case tuple_size(a) do
          2->
            "White wins - #{elem(a, 1)}"
          3->
            "White wins - #{elem(a, 1)} #{elem(a, 2)}"
        end
      3 ->
        "Tie"

      _ ->
        IO.puts("error")
    end
  end

  def test do
    :tata
  end
end
