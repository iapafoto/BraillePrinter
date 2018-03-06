/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package brailleprinter;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Container;
import java.awt.Graphics;
import java.awt.Graphics2D;
import static java.awt.RenderingHints.KEY_ANTIALIASING;
import static java.awt.RenderingHints.KEY_STROKE_CONTROL;
import static java.awt.RenderingHints.VALUE_ANTIALIAS_ON;
import static java.awt.RenderingHints.VALUE_STROKE_PURE;
import java.awt.Shape;
import java.awt.geom.AffineTransform;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Path2D;
import java.awt.geom.PathIterator;
import java.awt.geom.Point2D;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author durands
 */
public class PreviewPanel extends Container {

 //   final double cx1, cx2, cy1, cy2, r1, r2;
  //  final BufferedImage lineDrawn;
    final AffineTransform at;
    Shape drawingPath;
    
  //  final Rectangle2D drawingArea;
    
    Point2D currentPos;
    boolean isDrawing = false;
    BufferedImage imgDrawing = null;

    
 //   public PreviewPanel() {//AffineTransform at, BufferedImage lineDrawn, Rectangle2D drawingArea) {
//        this.cx1 = cx1;
//        this.cy1 = cy1;
//        this.cx2 = cx2;
//        this.cy2 = cy2;
//        this.r1 = r1;
//        this.r2 = r2;
    //    this.at = at;
     //   this.drawingArea = drawingArea;
     //   this.lineDrawn = lineDrawn;
   // }

    List<Point2D> lstDots;
            
    public PreviewPanel(Path2D drawingPath) {

        double scale = 3;
      //  lineDrawn = new BufferedImage((int)(210*scale), (int)(297*scale), BufferedImage.TYPE_INT_ARGB);
        at = AffineTransform.getScaleInstance(scale, scale);
     //   throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
        this.drawingPath = drawingPath.createTransformedShape(at);
        this.lstDots = getDots(this.drawingPath);
    }

    @Override
    public void paint(Graphics graphics) {
        Graphics2D g2 = (Graphics2D) graphics;

        //   g2.scale(1.5,1.5);
     //   g2.translate(400, 60);
        g2.setStroke(new BasicStroke(1));
        g2.setRenderingHint(KEY_ANTIALIASING, VALUE_ANTIALIAS_ON);
        g2.setRenderingHint(KEY_STROKE_CONTROL, VALUE_STROKE_PURE);

        g2.setColor(Color.red);
        g2.draw(drawingPath);
        
        g2.setColor(Color.black);
        for (Point2D pt : lstDots) {
            g2.fill(new Ellipse2D.Double(pt.getX()-2, pt.getY()-2,4,4));
        }
        
   //     g2.setColor(new Color(0, 0, 0, (int) ImageToDrawEvaluateLine.PEN_BLACKNESS));
        //      g2.draw(path);

/*
        g2.drawOval((int) (cx1 - r1), (int) (cy1 - r2), (int) (2 * r1), (int) (2 * r1));
        g2.drawOval((int) (cx2 - r2), (int) (cy2 - r2), (int) (2 * r2), (int) (2 * r2));

        double dtot = 850, d1, dt1, d2, dt2;

        // Distance a l'axe
        d1 = Math.sqrt((cx1 - currentPos.getX()) * (cx1 - currentPos.getX()) + (cy1 - currentPos.getY()) * (cy1 - currentPos.getY()));
        dt1 = Math.sqrt(d1 * d1 - r1 * r1);
        // Distance de corde enroulee (cas au dessus)
        double a1 = Math.asin(r1 / d1) + Math.asin(Math.abs(cy1 - currentPos.getY()) / d1);
        double angle1 = -3.14 - (Math.asin(r1 / d1) + Math.asin(Math.abs(cy1 - currentPos.getY()) / d1));
        double intx1 = cx1 + r1 * Math.sin(angle1);
        double inty1 = cy1 + r1 * Math.cos(angle1);
        double length1 = a1 * r1 + dt1;

        d2 = Math.sqrt((cx2 - currentPos.getX()) * (cx2 - currentPos.getX()) + (cy2 - currentPos.getY()) * (cy2 - currentPos.getY()));
        dt2 = Math.sqrt(d2 * d2 - r2 * r2);
        double a2 = Math.asin(r2 / d2) + Math.asin(Math.abs(cy2 - currentPos.getY()) / d2);
        double angle2 = -3.14 + (a2);
        double intx2 = cx2 + r2 * Math.sin(angle2);
        double inty2 = cy2 + r2 * Math.cos(angle2);
        double length2 = a2 * r2 + dt2;
//                g2.draw(new Ellipse2D.Double(intx1-3,inty1-3,6,6));

        g2.setColor(isDrawing ? Color.red : Color.green);
        g2.draw(new Ellipse2D.Double(currentPos.getX() - 3, currentPos.getY() - 3, 6, 6));

        g2.setColor(Color.blue);
        g2.fill(new Ellipse2D.Double(cx1 - r1 - 3, cy1 + (dtot - dt1) - 3, 6, 6));
        g2.setStroke(new BasicStroke(2.f, BasicStroke.JOIN_ROUND, BasicStroke.CAP_ROUND, 0, new float[]{10, 10}, 0));
        g2.draw(new Line2D.Double(currentPos.getX(), currentPos.getY(), intx1, inty1));
        g2.draw(new Line2D.Double(cx1 - r1, cy1 + (dtot - dt1), cx1 - r1, cy1));

        AffineTransform memAT = g2.getTransform();
        g2.rotate(length1 / r1, cx1, cy1);
        g2.setStroke(new BasicStroke(6.f, BasicStroke.JOIN_ROUND, BasicStroke.CAP_ROUND));
        g2.draw(new Line2D.Double(cx1 - 10, cy1, cx1 + 10, cy1));
        g2.draw(new Line2D.Double(cx1, cy1 - 10, cx1, cy1 + 10));
        g2.setTransform(memAT);

        g2.setColor(Color.red);
        g2.fill(new Ellipse2D.Double(cx2 + r2 - 3, cy2 + (dtot - dt2) - 3, 6, 6));
        g2.setStroke(new BasicStroke(2.f, BasicStroke.JOIN_ROUND, BasicStroke.CAP_ROUND, 0, new float[]{10, 10}, 0));
        g2.draw(new Line2D.Double(currentPos.getX(), currentPos.getY(), intx2, inty2));
        g2.draw(new Line2D.Double(cx2 + r2, cy2 + (dtot - dt2), cx2 + r2, cy2));

        //     memAT = g2.getTransform();
        g2.rotate(-length2 / r2, cx2, cy2);
        g2.setStroke(new BasicStroke(6.f, BasicStroke.JOIN_ROUND, BasicStroke.CAP_ROUND));
        g2.draw(new Line2D.Double(cx2 - 10, cy2, cx2 + 10, cy2));
        g2.draw(new Line2D.Double(cx2, cy2 - 10, cx2, cy2 + 10));
        g2.setTransform(memAT);

        g2.setColor(Color.red);
        g2.draw(drawingArea);
*/
    }
/*
    public void animatePanel(AffineTransform at, Path2D drawingPath, PreviewPanel panel) {
         
        if (lineDrawn != null) {
            imgDrawing = new BufferedImage(lineDrawn.getWidth(), lineDrawn.getHeight(), BufferedImage.TYPE_INT_ARGB);
            Graphics2D g2 = (Graphics2D) imgDrawing.getGraphics();
            g2.setRenderingHint(KEY_ANTIALIASING, VALUE_ANTIALIAS_ON);
            g2.setRenderingHint(KEY_STROKE_CONTROL, VALUE_STROKE_PURE);
            g2.setColor(Color.white);
            g2.fillRect(0, 0, imgDrawing.getWidth(), imgDrawing.getHeight());
            g2.setColor(Color.black);
            g2.draw(drawingPath.createTransformedShape(at));
            g2.dispose();
        }
        panel.repaint();

        currentPos = new Point2D.Double();
        Point2D lastPos = new Point2D.Double(0, 0);
        Point2D nextPos = new Point2D.Double();
        final double[] crds = new double[2];
        double x0 = 0, y0 = 0;
        double dt = .5;
        AffineTransform invAt = null;
        try {
            invAt = at.createInverse();
        } catch (NoninvertibleTransformException ex) {
            Logger.getLogger(PreviewPanel.class.getName()).log(Level.SEVERE, null, ex);
        }
        for (PathIterator pit = drawingPath.getPathIterator(null, .1); !pit.isDone(); pit.next()) {
            switch (pit.currentSegment(crds)) {
                case PathIterator.SEG_MOVETO:
                    nextPos.setLocation(crds[0], crds[1]);
                    isDrawing = false;
                    x0 = crds[0];
                    y0 = crds[1];
                    break;
                case PathIterator.SEG_LINETO:
                    // TODO si trop long depuis xlast, ylast couper en segments
                    nextPos.setLocation(crds[0], crds[1]);
                    isDrawing = true;
                    break;
                case PathIterator.SEG_CLOSE:
                    // TODO si trop long entre xlast, ylast et x0, y0 couper en segments
                    nextPos.setLocation(x0, y0);
                    isDrawing = true;
                    break;
                default:
            }

            double dist = nextPos.distance(lastPos);

            for (double d = 0; d < dist; d += dt) {
                currentPos = mix(lastPos, nextPos, Math.min(d / dist, 1.));
                panel.repaint();
                try {
                    Thread.sleep(10);
                } catch (InterruptedException e) {
                }
            }

            if (imgDrawing != null && isDrawing) {
                Graphics2D g2 = (Graphics2D) imgDrawing.getGraphics();
                g2.setRenderingHint(KEY_ANTIALIASING, VALUE_ANTIALIAS_ON);
                g2.setRenderingHint(KEY_STROKE_CONTROL, VALUE_STROKE_PURE);
                g2.transform(invAt);
                g2.setColor(new Color(0, 0, 0, 0));
                g2.draw(new Line2D.Double(lastPos.getX(), lastPos.getY(), nextPos.getX(), nextPos.getY()));
                g2.dispose();
            }

            lastPos.setLocation(nextPos);;
        }

    }
   */ 
    
    public static double mix(final double v1, final double v2, final double k) {
        return v1 + k*(v2 - v1);
    }
    
    public static Point2D mix(final Point2D v1, final Point2D v2, final double k) {
        return new Point2D.Double(mix(v1.getX(), v2.getX(), k), mix(v1.getY(), v2.getY(), k));
    }
    
    public List<Point2D> getDots(Shape drawingPath) {
        final double[] crds = new double[2];
        List<Point2D> lstPoints = new ArrayList();
        for (PathIterator pit = drawingPath.getPathIterator(null, .1); !pit.isDone(); pit.next()) {
            switch (pit.currentSegment(crds)) {
                case PathIterator.SEG_MOVETO:
                    lstPoints.add(new Point2D.Double(crds[0], crds[1]));
                    break;
                case PathIterator.SEG_LINETO:
                    lstPoints.add(new Point2D.Double(crds[0], crds[1]));
                    break;
                case PathIterator.SEG_CLOSE:
                default:
            }
        }
        return lstPoints;
    }
          
}

