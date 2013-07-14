import org.ini4j.Wini


/**
 * Win ini conf file.
 */
class WiniConf {

	def File file
	def Wini wini

	WiniConf(file){
		this.file = new File(file)
		this.wini = new Wini(this.file);
	}

	static WiniConf ini(file){
		new WiniConf(file);
	}

	def get(section, key){
		wini.get(section, key)
	}


	def put(section, key, value){
		wini.put(section, key, value)
	}

	def store(file){
		wini.store(new File(file));
	}
}
