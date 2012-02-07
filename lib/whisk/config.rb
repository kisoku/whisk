require 'whisk/bowl'

class Whisk
  class Config
    attr_accessor :bowls

    @@bowls = {}

    def self.add_bowl(bowl)
      @@bowls[bowl.name] = bowl
    end

    def self.bowls
      @@bowls
    end

    def self.bowl(name, &block)
      if self.bowls.has_key? name
        raise ArgumentError "bowl #{name} already exists"
      else
        b = Whisk::Bowl.new(name)
        b.instance_eval(&block)
        self.add_bowl(b)
      end
    end

    def self.from_file(filename)
      if ::File.exists?(filename) && ::File.readable?(filename)
        self.instance_eval(::IO.read(filename), filename, 1)
      else
        raise IOError, "Cannot open or read #{filename}!"
      end
    end
  end
end
