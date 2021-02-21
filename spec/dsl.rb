describe Berater::DSL do
  def check(expected, &block)
    expect(Berater::DSL.eval(&block)).to eq expected
  end

  context 'rate mode' do
    it 'has keywords' do
      check(:second) { second }
      check(:minute) { minute }
      check(:hour) { hour }
    end

    it 'parses' do
      check([ :rate, 1, :second ]) { 1.per second }
      check([ :rate, 3, :minute ]) { 3.per minute }
      check([ :rate, 5, :hour ]) { 5.every hour }
    end

    it 'cleans up afterward' do
      check([ :rate, 1, :second ]) { 1.per second }

      expect(Integer).not_to respond_to(:per)
      expect(Integer).not_to respond_to(:every)
    end

    it 'works with variables' do
      count = 1
      interval = :second

      check([ :rate, count, interval ]) { count.per interval }
    end
  end

  context 'concurrency mode' do
    it 'parses' do
      check([ :concurrency, 1 ]) { 1.at_once }
      check([ :concurrency, 3 ]) { 3.at_a_time }
      check([ :concurrency, 5 ]) { 5.concurrently }
    end

    it 'cleans up afterward' do
      check([ :concurrency, 1 ]) { 1.at_once }

      expect(Integer).not_to respond_to(:at_once)
      expect(Integer).not_to respond_to(:at_a_time)
      expect(Integer).not_to respond_to(:concurrently)
    end

    it 'works with constants' do
      class Foo
        CAPACITY = 3
      end

      check([ :concurrency, Foo::CAPACITY ]) { Foo::CAPACITY.at_once }
    end
  end

  context 'unlimited mode' do
    it 'has keywords' do
      check(:unlimited) { unlimited }
    end
  end

  context 'inhibited mode' do
    it 'has keywords' do
      check(:inhibited) { inhibited }
    end
  end

end
