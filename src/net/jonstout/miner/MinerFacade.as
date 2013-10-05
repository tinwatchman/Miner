package net.jonstout.miner
{
	import net.jonstout.miner.control.GenerateGameCommand;
	import net.jonstout.miner.data.Notification;
	import net.jonstout.miner.view.AlertMediator;
	import net.jonstout.miner.view.GameMediator;
	import net.jonstout.miner.view.StartMediator;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class MinerFacade extends Facade
	{
		protected static var instance:MinerFacade;
		
		public static function getInstance():MinerFacade {
			if (instance == null) {
				instance = new MinerFacade(new SingletonEnforcer());
			}
			return instance;
		}
		
		public function MinerFacade(enforcer:SingletonEnforcer)
		{
			super();
		}
		
		public function start(app:MinerApplication):void {
			// create mediators
			registerMediator(new ApplicationMediator(app));
			registerMediator(new StartMediator());
			registerMediator(new GameMediator());
			registerMediator(new AlertMediator());
			
			//register commands
			registerCommand(Notification.GENERATE_GAME, GenerateGameCommand);
			
			sendNotification(Notification.STARTUP_COMPLETE);
		}
	}
} class SingletonEnforcer {}