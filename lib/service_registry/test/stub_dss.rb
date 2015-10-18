module ServiceRegistry
  module Test
    class StubDSS
      attr_reader :selected, :broken, :error

      def initialize
        @selected = {}
      end

      def select(service)
        @selected[service['id']] = service
      end

      def deselect(service)
        @selected.delete(service['id'])
      end

      def query(id)
        return 'error' if @error
        return nil if @broken
        not @selected[id].nil?
      end

      def break
        @broken = true
      end

      def error
        @error = true
      end

      def fix
        @broken = false
        @error = false
      end
    end
  end 
end
