class PermissionsPresenter

  def initialize(set)
    @set = set
  end

  def name
    @set.name
  end

  def headers
    header_keys.map{|action| action.titleize }
  end

  def rows
    row_keys.map do |row|
      name = row.titleize

      permissions = header_keys.map do |header|
        @set.permissions.find{|permission| permission =~ /\.#{row}\.#{header}$/ }
      end

      RowPresenter.new(name, permissions)
    end
  end

  private

  def header_keys
    @set.permissions.map{|p| p.split(".").last }.uniq
  end

  def row_keys
    @set.permissions.map{|p| p.split(".")[-2] }.uniq
  end

  RowPresenter = Struct.new(:name, :permissions)

end
