import sounddevice as sd
import soundfile as sf

# Settings
filename = 'my_song.ogg'
duration = 10  # seconds
samplerate = 44100  # CD quality
channels = 1  # stereo

print("Recording...")
audio = sd.rec(int(duration * samplerate), samplerate=samplerate, channels=channels)
sd.wait()
print("Recording complete.")

# Save as Ogg Vorbis
sf.write(filename, audio, samplerate, format='OGG', subtype='VORBIS')
print(f"Saved as {filename}")
