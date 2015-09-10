module ServiceRegistry

  module Factory

    class EnvironmentContext

      class EnvDict < Hash

        def initialize(env, *path)
          @env = env
          @path = build_path(*path)

          env_keys.each do |k|
            self.store(symbolic_key(k), @env[k])
          end

          self.default_proc = envdict_default_proc
        end

        def subslice(key)
          EnvDict.new(@env, @path, key).tap do |s|
            (@slices ||= []) << s
          end
        end

        def subslice!(key)
          delete_keys_prefixed_with!(key)
          subslice(key)
        end

        def scrub!
          @path or raise RuntimeError, "refusing to scrub without path"

          scrub_env!
          scrub_slices!
          scrub_self!

          @scrubbed = true
        end

        private

          def envdict_default_proc
            proc do |_, key|
              assert_not_scrubbed!
              try_string(key) or raise_key_error(key)
            end
          end

          def try_string(k)
            if (skey = k.intern rescue false) and self.include?(skey)
              self.fetch(skey)
            end
          end

          def raise_key_error(k)
            envar = build_path(@path, k.to_s).upcase
            raise KeyError, "missing environment variable #{envar}"
          end

          def env_keys
            @env.keys.select { |k| under_path?(k) }
          end

          def under_path?(k)
            !!symbolic_key(k)
          end

          def symbolic_key(k)
            prefix = build_path(@path, "")
            s = k.downcase
            if s.slice!(prefix) and !s.empty?
              s.intern
            end
          end

          def build_path(*path)
            path = path.compact
            if path.empty?
              nil
            else
              path.map { |p| p.to_s.downcase }.join("_")
            end
          end

          def delete_keys_prefixed_with!(key)
            self.keys.each do |k|
              if k.to_s.start_with?("#{key}_")
                self.delete(k)
              end
            end
          end

          def assert_not_scrubbed!
            !@scrubbed or raise SecurityError, "can't access scrubbed environment dictionary"
          end

          def scrub_env!
            env_keys.each do |k|
              @env.delete(k)
            end
          end

          def scrub_slices!
            @slices.each { |s| s.scrub! } if @slices
          end

          def scrub_self!
            self.keys.each do |k|
              self.delete(k)
            end
          end

      end

    end

  end

end
