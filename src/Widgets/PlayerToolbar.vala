using Gtk;

namespace Gradio{

	[GtkTemplate (ui = "/de/haecker-felix/gradio/ui/player-toolbar.ui")]
	public class PlayerToolbar : Gtk.Box{

		[GtkChild]
		private Image PlayImage;
		[GtkChild]
		private Image StopImage;
		[GtkChild]
		private Label ChannelNameLabel;
		[GtkChild]
		private Label ChannelCurrentTitleLabel;
		[GtkChild]
		private Image StationLogo;

		[GtkChild]
		private Label NominalBitrateLabel;
		[GtkChild]
		private Label MinimumBitrateLabel;
		[GtkChild]
		private Label MaximumBitrateLabel;
		[GtkChild]
		private Label BitrateLabel;
		[GtkChild]
		private Label CodecLabel;
		[GtkChild]
		private Label ChannelModeLabel;

		RadioStation station;

		public PlayerToolbar(){
			App.player.state_changed.connect (() => refresh_play_stop_button());
			App.player.tag_changed.connect (() => set_information());
		}

		public void set_radio_station (RadioStation s){
			station = s;

			ChannelNameLabel.set_text(station.Title);

			Gdk.Pixbuf icon = null;
			Util.get_image_from_url.begin(station.Icon, 40, 40, (obj, res) => {
		        	icon = Util.get_image_from_url.end(res);

				if(icon != null){
					StationLogo.set_from_pixbuf(icon);
				}else{
					StationLogo.set_from_icon_name("application-rss+xml-symbolic", IconSize.DND);		
				}
				
        		});
			
			string css = """
			* {
				border-width: 1px 1px 1px 1px;
				border-style: solid;
				border-color: @borders;
			}
			""";

			Gtk.CssProvider provider = new Gtk.CssProvider();
			provider.load_from_data(css, css.length);
			StationLogo.get_style_context().add_provider(provider, 1);

			this.set_visible(true);
		}

		[GtkCallback]
        	private void PlayStopButton_clicked (Button button) {
			App.player.toggle_play_stop();
			refresh_play_stop_button();
		}

		[GtkCallback]
        	private void VolumeButton_value_changed (double value) {
			App.player.set_volume(value);
		}

		private void set_information(){
			ChannelCurrentTitleLabel.set_text(App.player.tag_title);
			NominalBitrateLabel.set_text(App.player.tag_nominal_bitrate.to_string() + " Bit/s");
			MinimumBitrateLabel.set_text(App.player.tag_minimum_bitrate.to_string() + " Bit/s");
			MaximumBitrateLabel.set_text(App.player.tag_maximum_bitrate.to_string() + " Bit/s");
			BitrateLabel.set_text(App.player.tag_bitrate.to_string()  + " Bit/s");
			CodecLabel.set_text(App.player.tag_audio_codec);
			ChannelModeLabel.set_text(App.player.tag_channel_mode);
		}

		private void refresh_play_stop_button(){
			if(App.player.is_playing()){
				StopImage.set_visible(true);
				PlayImage.set_visible(false);
			}else{
				PlayImage.set_visible(true);
				StopImage.set_visible(false);
			}
		}
	}
}
