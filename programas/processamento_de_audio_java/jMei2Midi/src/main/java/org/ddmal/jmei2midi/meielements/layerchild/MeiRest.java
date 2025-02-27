/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.ddmal.jmei2midi.meielements.layerchild;

import ca.mcgill.music.ddmal.mei.MeiElement;
import javax.sound.midi.Sequence;

import org.ddmal.jmei2midi.meielements.general.MeiData;
import org.ddmal.jmei2midi.meielements.general.MeiMeasure;
import org.ddmal.jmei2midi.meielements.meispecific.MeiSpecificStorage;
import org.ddmal.jmei2midi.meielements.staffinfo.MeiStaff;
import org.ddmal.midiUtilities.ConvertToMidi;

/**
 * MeiRest accounts for rest, mRest, space and mSpace.
 * Will increase the tick count of the appropriate staff without
 * changing anything else in terms of midi info.
 * @author Tristano Tenaglia
 */
public class MeiRest extends LayerChild {
    private final MeiElement rest;
    private final long startTick;
    private final long endTick;
    
    /**
     * Process a rest by only adding to the layer tick count of currentStaff
     * without actually creating any midi events.
     * @param currentStaff the current staff to be processed
     * @param currentMeasure the current measure to be processed
     * @param sequence the current sequence to be added to
     * @param rest the mei rest element to be processed
     */
    public MeiRest(MeiStaff currentStaff, MeiMeasure currentMeasure, Sequence sequence,
                   MeiElement rest, MeiSpecificStorage nonMidiStorage, MeiData meiData) {
        super(currentStaff, currentMeasure, sequence, rest, nonMidiStorage, meiData);
        this.rest = rest;
        
        //Get the proper start and end Ticks for this rest
        this.startTick = currentStaff.getTick() + currentStaff.getTickLayer();
        this.endTick = startTick + getDurToTick();
        
        //Change the layers tick accordingly
        currentStaff.setTickLayer(endTick - currentStaff.getTick());
    }
    
    @Override
    /**
     * Converts given duration string to a long tick value for midi.
     * thiStaff can be populated with a tuplet or note which will then
     * be used to compute tuplet and dot values in the duration.
     * ASSUMPTION
     * This assumes that if not dur is given in element or chord
     * then the note takes up a full measure.
     * @return long tick value of dur string
     */
    public long getDurToTick() {
        //CHECK IN HERE FOR TUPLETS FROM tupletSpan
        //If in tuplet then use that or else check tupletSpan
        int num = currentMeasure.getNum();
        int numbase = currentMeasure.getNumBase();
        String dur = getDurString();
        int dots = getDots();
        return ConvertToMidi.durToTick(dur,num,numbase,dots);
    }
    
    @Override
    /**
     * Fetches the appropriate duration of a given Mei rest depending on
     * whether it's a note, a chord or a rest/space.
     * If no duration is found, then a dur = "0" is returned.
     * @return duration of rest in string form
     */
    public String getDurString() {
        String dur;
        //Else assume it is an entire measure
        //Could replace this with 
        //else if(rest.getName().equals("mRest" || "mSpace))
        if(rest.getName().equals("mRest") ||
           rest.getName().equals("mSpace")){
            double count = Integer.parseInt(currentStaff.getMeterCount());
            double unit = Integer.parseInt(currentStaff.getMeterUnit());
            dur = String.valueOf(unit / count);
        }
        //For notes and rests with dur attributes
        else if(attributeExists(rest.getAttribute("dur"))) {
            dur = rest.getAttribute("dur");
            //GRACE NOTE DURATION CAN BE CHANGED HERE
        }
        else {
            dur = "0";
        }
        return dur;
    }
    
    @Override
    /**
     * Fetches the appropriate dots for the given mei element depending
     * on if it's a chord or a note.
     * If no dots are found, then a dots = 0 value is returned.
     * @return number of corresponding dots for element
     */
    public int getDots() {
        int dots = getAttributeToInt("dots", rest, 0);
        return dots;
    }
}
