class AddSoundtoInstrumentTable < ActiveRecord::Migration[4.2]
  def change
    add_coulmn :instruments, :sound, :string
  end
end
