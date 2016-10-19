module ZeroDowntimeMigrations
  class Validation
    class MixedMigration < Validation
      def validate!
        return unless Migration.mixed?
        error!(message)
      end

      private

      def message
        <<-MESSAGE.strip_heredoc
          Mixing data/index/schema changes in the same migration is unsafe!

          Instead, let's split apart these types of migrations into separate files.

          * Introduce schema changes with methods like `create_table` or `add_column` in one file.
          * Update data with methods like `update_all` or `save` in another file.
          * Add indexes concurrently within their own file as well.

          If you're 100% positive that this migration is already safe, then simply
          add a call to `safety_assured` to your migration.

            class #{migration_name} < ActiveRecord::Migration
              safety_assured

              def change
                # ...
              end
            end
        MESSAGE
      end
    end
  end
end
