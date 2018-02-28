import info.gridworld.actor.Actor;
import info.gridworld.actor.Flower;
import info.gridworld.actor.Rock;
import info.gridworld.grid.Grid;
import info.gridworld.grid.Location;

import java.awt.Color;

public class LilDeath extends Actor {
    public LilDeath() {
        setColor(Color.BLACK);
    }

    public LilDeath(Color LilDeathColor) {
        setColor(LilDeathColor);
    }

    public void act() {
        if (canJump())
            jump();
        else
            turn();
        turn();
    }

    public void turn() {
        if ((int) (Math.random() * 2) == 1)
            setDirection(getDirection() + Location.HALF_RIGHT);
        else
            setDirection(getDirection() + Location.HALF_LEFT);
    }

    public void jump() {
        Grid<Actor> gr = getGrid();
        if (gr == null)
            return;
        Location loc = getLocation();
        Location next = loc.getAdjacentLocation(getDirection());
        if (gr.isValid(next))
            moveTo(next);
        else
            removeSelfFromGrid();
    }

    public boolean canJump() {
        Grid<Actor> gr = getGrid();
        if (gr == null)
            return false;
        Location loc = getLocation();
        Location next = loc.getAdjacentLocation(getDirection());
        return gr.isValid(next);
    }
}
